# frozen_string_literal: true

class Product
  attr_reader :name, :count, :price

  def initialize(name, price, count)
    @name = name
    @price = price
    @count = count
  end

  def increase_count(increment = 1)
    @count += increment
  end

  def decrease_count(decrement = 1)
    raise CannotBeLessThanZeroError if (count - decrement).negative?

    @count -= decrement
  end
end
