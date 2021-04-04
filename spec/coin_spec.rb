# frozen_string_literal: true

require 'coin'
require 'errors'

RSpec.describe Coin do
  it 'should initialise a coin with any of our denominator values and no count' do
    denominators = [1, 2, 5, 10, 50, 100, 200]
    denominators.each { |den| Coin.new(den) }
  end

  it 'should initialise a coin with a count' do
    coin = Coin.new(1, 1000)
    expect(coin.count).to eq(1000)
  end

  it 'should raise an error if a non-denominator value is used' do
    expect { Coin.new(3, 1000) }.to raise_error(ArgumentError)
  end

  it 'should increase a coins count' do
    coin = Coin.new(1, 1000)
    coin.increase_count
    expect(coin.count).to eq(1001)
    coin.increase_count(100)
    expect(coin.count).to eq(1101)
  end

  it 'should decrease a coins count' do
    coin = Coin.new(1, 1000)
    coin.decrease_count
    expect(coin.count).to eq(999)
    coin.decrease_count(100)
    expect(coin.count).to eq(899)
  end

  it 'should raise an error if we try to decrease to less than 0' do
    coin = Coin.new(1, 1000)
    coin.decrease_count
    expect { coin.decrease_count(1001) }.to raise_error(CannotBeLessThanZeroError)
  end
end
