# frozen_string_literal: true

class Messenger
  def send_message(msg, msg_type = :info)
    puts "#{prefix(msg_type)}#{msg}"
  end

  private

  def prefix(msg_type)
    case msg_type.to_sym
    when :error
      'Error: '
    when :info
      'Info: '
    else
      ''
    end
  end
end
