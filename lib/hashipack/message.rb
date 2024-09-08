module Hashipack
  class Message
    def self.parse(line)
      msg = Message.new(line)
      if msg.ui?
        UiMessage.new(line)
      elsif msg.artifact?
        ArtifactMessage.new(line)
      else
        OtherMessage.new(line)
      end
    end

    def initialize(line)
      line = line.force_encoding('UTF-8')
      line = line.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      @parts = line.split(",")
    end

    def timestamp
      @parts.first.to_i
    end

    def type
      @parts[2]
    end

    def ui?
      type == 'ui'
    end

    def artifact?
      type == 'artifact'
    end
  end

  class UiMessage < Message
    def type
      :ui
    end

    def text
      @parts[4]
    end
  end

  class OtherMessage < Message
    def type
      :other
    end

    def text
      @parts.join(',')
    end
  end

  class ArtifactMessage < Message
    def type
      :artifact
    end

    def number
      @parts[3].to_i
    end

    def key
      @parts[4]
    end

    def value
      @parts[5]
    end
  end
end
