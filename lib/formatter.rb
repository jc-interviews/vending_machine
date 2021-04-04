# frozen_string_literal: true

module Formatter
  # TODO: thousandth seperator
  def self.currency(pence_value)
    "£#{format('%.2f', (pence_value.to_f / 100))}"
  end
end
