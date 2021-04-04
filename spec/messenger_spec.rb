# frozen_string_literal: true

require 'messenger'

RSpec.describe Messenger do
  it 'should output a message to stdout' do
    messenger = Messenger.new
    message = 'I am the best'
    expected_output = "Info: #{message}\n"
    expect { messenger.send_message(message) }.to output(expected_output).to_stdout
    message = 'I am the error'
    expected_output = "Error: #{message}\n"
    expect { messenger.send_message(message, :error) }.to output(expected_output).to_stdout
  end
end
