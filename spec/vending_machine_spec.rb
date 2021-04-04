# frozen_string_literal: true

require 'vending_machine'
require 'coin_stack'
require 'constants'
require 'inventory'
require 'product'
require 'errors'

RSpec.describe VendingMachine do
  before(:each) do
    @inventory = Inventory.new([
                                 Product.new('Orange juice', 150, 100),
                                 Product.new('Water', 100, 20),
                                 Product.new('Cola', 200, 50),
                                 Product.new('Apple Juice', 150, 0)
                               ])

    @coin_stack = CoinStack.new([
                                  Coin.new(1, 1000),
                                  Coin.new(2, 867),
                                  Coin.new(5, 400),
                                  Coin.new(10, 566),
                                  Coin.new(20, 1000),
                                  Coin.new(50, 500),
                                  Coin.new(100, 1220),
                                  Coin.new(200, 160)
                                ])
    @vm = VendingMachine.new(@inventory, @coin_stack)
  end

  it 'should reload a product' do
    @vm.reload_product('Orange juice', 1)
    expect(@vm.inventory.find_product_by_name('Orange juice').count).to eq(101)
  end

  it 'should reload a coin' do
    one_penny_coin = @vm.coin_stack.find_by_coin_denominator(1)
    expect(one_penny_coin.count).to eq(1000)

    @vm.reload_coin(1, 100)
    expect(one_penny_coin.count).to eq(1100)
  end

  it 'should insert a coin' do
    one_penny_coin = @vm.coin_stack.find_by_coin_denominator(1)
    expect(one_penny_coin.count).to eq(1000)

    @vm.insert_coin(1)
    @vm.insert_coin(1)
    expect(one_penny_coin.count).to eq(1002)
    expect(@vm.inserted_coins_value).to eq(2)
  end

  it 'should allow ejection of coins' do
    @vm.insert_coin(1)
    @vm.insert_coin(1)
    ejected_coins = @vm.eject_coins
    expect(ejected_coins.reduce(:+)).to eq(2)
  end

  it 'should purchase a product and return no change' do
    @vm.insert_coin(100)
    @vm.insert_coin(50)

    output = nil

    expect do
      output = @vm.purchase_product('Orange juice')
    end.to output("Info: You have bought Orange juice for £1.50. Your change is £0.00.\n").to_stdout

    expect(@vm.inserted_coins_value).to eq(0)
    expect(@vm.inventory.find_product_by_name('Orange juice').count).to eq(99)
    expect(output[:change].empty?).to eq(true)
    expect(output[:product_name]).to eq('Orange juice')
  end

  it 'should purchase a product and return some change' do
    @vm.insert_coin(200)
    output = nil

    expect do
      output = @vm.purchase_product('Water')
    end.to output("Info: You have bought Water for £1.00. Your change is £1.00.\n").to_stdout

    expect(@vm.inserted_coins_value).to eq(0)
    expect(@vm.inventory.find_product_by_name('Water').count).to eq(19)
    expect(output[:change]).to eq([100])
    expect(output[:product_name]).to eq('Water')

    expect(@vm.coin_stack.find_by_coin_denominator(100).count).to eq(1219)
  end

  it 'should not allow the purchase of a product when insufficient funds have been inserted,'\
     ' but should allow user to enter missing amount and continue' do
    @vm.insert_coin(100)
    output = nil

    expect do
      output = @vm.purchase_product('Cola')
    end.to output("Error: Insufficient payment, please provide an additional £1.00\n").to_stdout

    expect(@vm.inserted_coins_value).to eq(100)
    expect(@vm.inventory.find_product_by_name('Cola').count).to eq(50)
    expect(output[:change].empty?).to eq(true)
    expect(output[:product_name]).to eq(nil)

    @vm.insert_coin(100)
    expect(@vm.inserted_coins_value).to eq(200)
    expect do
      output = @vm.purchase_product('Cola')
    end.to output("Info: You have bought Cola for £2.00. Your change is £0.00.\n").to_stdout

    expect(@vm.inserted_coins_value).to eq(0)
    expect(@vm.inventory.find_product_by_name('Cola').count).to eq(49)
    expect(output[:change]).to eq([])
    expect(output[:product_name]).to eq('Cola')
  end

  it 'should not allow purchase if product does not exist and should return coins' do
    @vm.insert_coin(100)
    output = nil

    expect do
      output = @vm.purchase_product('Lemonade')
    end.to output("Error: ProductNotAvailableError\nInfo: Change has been returned\n").to_stdout

    expect(@vm.inserted_coins_value).to eq(0)
    expect(output[:change]).to eq([100])
    expect(output[:product_name]).to eq(nil)
  end
end
