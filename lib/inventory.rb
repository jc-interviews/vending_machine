# frozen_string_literal: true

class Inventory
  attr_reader :products

  def initialize(products)
    @products = products
  end

  def find_product_by_name(product_name)
    # convert to lowercase symbols to be a bit safer
    # should probably be doing this with a product_code rather than a name
    product = @products.find { |p| p.name.downcase.to_sym == product_name.downcase.to_sym }
    raise ProductNotAvailableError unless product

    product
  end

  def decrease_count(product_name, count = 1)
    product = find_product_by_name(product_name)
    product.decrease_count(count)
  end

  def increase_count(product_name, count = 1)
    product = find_product_by_name(product_name)
    product.increase_count(count)
  end
end
