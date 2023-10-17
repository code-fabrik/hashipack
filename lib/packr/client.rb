require 'tempfile'

module Packr
  class Client
    def build(content, on_output: lambda{}, on_progress: lambda{}, estimated_duration: 300)
      template = Tempfile.new(["template", ".pkr.hcl"])
      template.write(content)
      template.close
      command = "packer -machine-readable build #{template.path}"

      initial_timestamp = 99999999999
      last_timestamp = 0

      artifacts = []

      IO.popen(command).each do |line|

        message = Message.parse(line)

        if message.type == :ui
          initial_timestamp = message.timestamp if message.timestamp < initial_timestamp

          if message.timestamp > last_timestamp
            last_timestamp = message.timestamp
            running_duration = message.timestamp - initial_timestamp
            progress = running_duration / estimated_duration.to_f
            on_progress.call(progress)
          end

          on_output.call(message.text)

        elsif message.type == :artifact

          artifacts[message.number] ||= Artifact.new
          artifacts[message.number].append_info(message.key, message.value)

        end
      end

      return artifacts
    end
  end
end
