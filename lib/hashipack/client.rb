require 'tempfile'
require 'open3'

module Hashipack
  class Client
    def build(path, on_output: lambda {}, on_progress: lambda {}, estimated_duration: 300, debug: false, machine_readable: true, additional_options: '')
      directory, filename = File.split(path)
      debug_option = debug ? '-debug' : ''
      machine_readable_option = machine_readable ? '-machine-readable' : ''
      command = "packer build #{machine_readable_option} #{debug_option} #{additional_options} #{filename}"

      initial_timestamp = 99999999999
      last_timestamp = 0

      artifacts = []

      Open3.popen3(command, chdir: directory) do |stdin, stdout, stderr, wait_thr|
        stdout.each do |line|
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

          elsif message.type == :other
            on_output.call(message.text)
          end
        end

        stderr.each do |line|
          puts "Error: #{line}"
        end

        puts "Exit status: #{wait_thr.value}"
      end

      artifacts
    end
  end
end
