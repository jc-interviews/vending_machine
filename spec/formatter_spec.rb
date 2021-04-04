# frozen_string_literal: true

require 'formatter'

RSpec.describe Formatter do
  it 'should format to currency' do
    test_cases = {
      100 => '£1.00',
      50 => '£0.50',
      500 => '£5.00',
      123 => '£1.23'
    }
    test_cases.each do |value, formatted_value|
      expect(Formatter.currency(value)).to eq(formatted_value)
    end
  end
end
