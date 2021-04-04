# frozen_string_literal: true

class Coin
  attr_reader :value, :count

  def initialize(value, count = 0)
    @value = value
    @count = count

    return if valid?

    raise ArgumentError,
          'Value must be a valid denominator. Valid denominators: '\
          "#{Constants::COIN_DENOMINATORS.join(' ')}. Value received: #{@value}"
  end

  def increase_count(increment = 1)
    @count += increment
  end

  def decrease_count(decrement = 1)
    raise CannotBeLessThanZeroError if (count - decrement).negative?

    @count -= decrement
  end

  private

  def valid?
    Constants::COIN_DENOMINATORS.include?(@value)
  end
end
