# frozen_string_literal: true

RSpec.describe Hashipack::Client do
  it 'runs packer' do
    packer_client = Hashipack::Client.new

    print_message = ->(message) { puts message }
    print_progress = ->(progress) { puts progress * 100 }

    packer_client.build('spec/docker.pkr.hcl', on_output: print_message, on_progress: print_progress, estimated_duration: 5)
  end
end
