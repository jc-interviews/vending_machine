# frozen_string_literal: true

class CoinStack
  attr_reader :coins

  def initialize(coins = [])
    @coins = init_coins(coins)
  end

  def find_by_coin_denominator(denominator)
    coin = @coins.find { |c| denominator == c.value }
    unless coin
      raise ArgumentError,
            'Value must be a valid denominator. Valid denominators: '\
            "#{Constants::COIN_DENOMINATORS.join(' ')}. Value received: #{denominator}"
    end
    coin
  end

  def increase_count(denominator, increase_by = 1)
    coin = find_by_coin_denominator(denominator)
    coin.increase_count(increase_by)
  end

  def decrease_count(denominator, decrease_by = 1)
    coin = find_by_coin_denominator(denominator)
    coin.decrease_count(decrease_by)
  end

  def total_value
    @coins.reduce(0) { |sum, coin| sum + (coin.value * coin.count) }
  end

  # takes a simple array e.g. [1, 1, 1, 2]
  # would decrement our 1p by 3 and our 2p by 1
  def decrease_coins_from_list(coin_list)
    coin_list.each do |coin_value|
      decrease_count(coin_value)
    end
  end

  # NOTE: this algorithm can fail in some cases
  # if our available change ever gets low
  # details in the README
  def change_to_return(required_change)
    return [] unless required_change.positive?

    coin_value_list = []
    remaining_change = required_change
    coins.sort_by(&:value).reverse.each do |coin|
      remaining_coin_count = coin.count
      break if remaining_coin_count.zero?

      until remaining_coin_count.zero? || coin.value > remaining_change

        coin_value_list.push(coin.value)
        remaining_change -= coin.value
        remaining_coin_count -= 1
      end
    end

    raise ExactChangeNotAvailableError if coin_value_list.reduce(:+) != required_change

    coin_value_list
  end

  private

  def init_coins(loaded_coins)
    default_coins.map do |coin|
      loaded_coin = loaded_coins.find { |l_c| l_c.value == coin.value }
      loaded_coin || coin
    end
  end

  def default_coins
    Constants::COIN_DENOMINATORS.map { |den| Coin.new(den, 0) }
  end
end
