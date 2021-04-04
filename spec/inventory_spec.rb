# frozen_string_literal: true

require 'inventory'
require 'product'
require 'errors'

RSpec.describe Inventory do
  before(:each) do
    @orange_juice_product = Product.new('Orange Juice', 150, 10)
    @apple_juice_product = Product.new('Apple Juice', 100, 10)
    @inventory = Inventory.new([
                                 @orange_juice_product,
                                 @apple_juice_product
                               ])
  end

  it 'should find a product by name, case insentitive' do
    expect(@inventory.find_product_by_name('Orange Juice')).to eq(@orange_juice_product)
    expect(@inventory.find_product_by_name('orange juice')).to eq(@orange_juice_product)
    expect(@inventory.find_product_by_name('ORANGE JUICE')).to eq(@orange_juice_product)
  end

  it 'should increase a product count' do
    @inventory.increase_count('Orange juice', 100)
    expect(@inventory.find_product_by_name('Orange Juice').count).to eq(110)
  end

  it 'should decrease a product count' do
    @inventory.decrease_count('Orange juice', 10)
    expect(@inventory.find_product_by_name('Orange Juice').count).to eq(0)
  end
end
