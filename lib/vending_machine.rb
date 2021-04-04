# frozen_string_literal: true

require_relative 'errors'
require_relative 'coin_stack'
require_relative 'coin'
require_relative 'constants'
require_relative 'formatter'
require_relative 'inventory'
require_relative 'messenger'
require_relative 'product'

class VendingMachine
  attr_reader :inventory, :coin_stack, :inserted_coins_value

  def initialize(inventory, coin_stack)
    @inventory = inventory
    @coin_stack = coin_stack
    @inserted_coins_value = 0
    @messenger = Messenger.new
  end

  def insert_coin(coin_value)
    @coin_stack.increase_count(coin_value)
    @inserted_coins_value += coin_value
    @inserted_coins_value
  end

  def reload_product(product_name, increase_by)
    @inventory.increase_count(product_name, increase_by)
  end

  def reload_coin(coin_value, increase_by)
    @coin_stack.increase_count(coin_value, increase_by)
  end

  def eject_coins
    coins_list = @coin_stack.change_to_return(@inserted_coins_value)
    reset_inserted_coins_value
    coins_list
  end

  def purchase_product(product_name)
    product = @inventory.find_product_by_name(product_name)
    raise ProductOutOfStockError unless product.count.positive?

    # positive diff means change is due
    # negative diff means user has not paid enough
    diff = @inserted_coins_value - product.price
    if diff.negative?
      raise InsufficientFundsError,
            "Insufficient payment, please provide an additional #{Formatter.currency(diff.abs)}"
    end

    dispence(product, diff)
  rescue InsufficientFundsError => e
    @messenger.send_message(e, :error)

    dispence_output(nil, [])
  rescue ExactChangeNotAvailableError, ProductOutOfStockError, ProductNotAvailableError => e
    change = eject_coins
    @messenger.send_message(e, :error)
    @messenger.send_message('Change has been returned')

    dispence_output(nil, change)
  end

  def machine_balance
    @coin_stack.total_value
  end

  private

  def dispence(product, diff)
    change = @coin_stack.change_to_return(diff)
    @coin_stack.decrease_coins_from_list(change)
    @inventory.decrease_count(product.name)
    reset_inserted_coins_value

    @messenger.send_message(
      "You have bought #{product.name} for #{Formatter.currency(product.price)}."\
      " Your change is #{Formatter.currency(change.empty? ? 0 : change.reduce(:+))}.",
      :info
    )

    dispence_output(product.name, change)
  end

  def dispence_output(product_name, change)
    { product_name: product_name, change: change }
  end

  def reset_inserted_coins_value
    @inserted_coins_value = 0
  end

  def exact_change_available?; end

  def enough_change?; end
end
