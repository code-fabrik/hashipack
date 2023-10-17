module Packr
  class Artifact
    attr_reader :builder_id, :id, :string, :files_count

    def append_info(key, value)
      case key.to_s
      when 'builder-id'
        @builder_id = value
      when 'id'
        @id = value
      when 'string'
        @string = value
      when 'files_count'
        @files_count = value
      end
    end
  end
end
