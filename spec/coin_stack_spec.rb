# frozen_string_literal: true

require 'coin_stack'
require 'coin'

RSpec.describe CoinStack do
  before(:each) do
    @one_penny_coin = Coin.new(1, 1000)
    @coin_stack = CoinStack.new([
                                  @one_penny_coin,
                                  Coin.new(2, 867),
                                  Coin.new(5, 400),
                                  Coin.new(10, 566),
                                  Coin.new(20, 1000),
                                  Coin.new(50, 500),
                                  Coin.new(100, 1220),
                                  Coin.new(200, 160)
                                ])
  end
  it 'Initialises a CoinStack with no initial values passed in' do
    coin_stack = CoinStack.new

    expect(coin_stack.coins.count).to eq(8)
    expect(coin_stack.coins.map(&:value)).to match_array([1, 2, 5, 10, 20, 50, 100, 200])
    expect(coin_stack.coins.map(&:count)).to match_array(Array.new(8, 0))
  end

  it 'Initialises a CoinStack with initial values passed in' do
    coin_stack = CoinStack.new([
                                 Coin.new(1, 20),
                                 Coin.new(200, 10)
                               ])

    expect(coin_stack.coins.count).to eq(8)
    expect(coin_stack.coins.map(&:value)).to match_array([1, 2, 5, 10, 20, 50, 100, 200])
    expect(coin_stack.coins.map(&:count)).to match_array([20, 0, 0, 0, 0, 0, 0, 10])
  end

  it 'should find a coin by denominator' do
    expect(@coin_stack.find_by_coin_denominator(1)).to eq(@one_penny_coin)
  end

  it 'should increase a coin count' do
    @coin_stack.increase_count(1, 100)
    expect(@coin_stack.find_by_coin_denominator(1).count).to eq(1100)
  end

  it 'should decrease a coin count' do
    @coin_stack.decrease_count(1, 100)
    expect(@coin_stack.find_by_coin_denominator(1).count).to eq(900)
  end

  it 'should decrease coins from a list of demoninators' do
    expect(@coin_stack.find_by_coin_denominator(1).count).to eq(1000)
    expect(@coin_stack.find_by_coin_denominator(2).count).to eq(867)
    @coin_stack.decrease_coins_from_list([1, 1, 2, 1, 1, 1])
    expect(@coin_stack.find_by_coin_denominator(1).count).to eq(995)
    expect(@coin_stack.find_by_coin_denominator(2).count).to eq(866)
  end

  it 'should calculate the correct total value' do
    coin_stack = CoinStack.new([
                                 Coin.new(50, 500),
                                 Coin.new(100, 1220),
                                 Coin.new(200, 160)
                               ])
    expect(coin_stack.total_value).to eq(179_000)
  end
end
