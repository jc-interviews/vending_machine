# frozen_string_literal: true

require 'product'
require 'errors'

RSpec.describe Product do
  before(:each) do
    @product = Product.new('Apple juice', 150, 15)
  end

  it "should increase a product's count" do
    @product.increase_count
    expect(@product.count).to eq(16)
    @product.increase_count(100)
    expect(@product.count).to eq(116)
  end

  it 'should decrease a coins count' do
    @product.decrease_count
    expect(@product.count).to eq(14)
    @product.decrease_count(10)
    expect(@product.count).to eq(4)
  end

  it 'should raise an error if we try to decrease to less than 0' do
    expect { @product.decrease_count(16) }.to raise_error(CannotBeLessThanZeroError)
  end
end
