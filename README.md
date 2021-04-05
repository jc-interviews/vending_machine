# Requirements/brief

We'd like you to write the code for a vending machine that satisfies the following requirements:
* The machine should take an initial load of products and change
* Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product
* The machine should ask for more money if insufficient funds have been inserted
* The change will be of denominations: 1p, 2p, 5p, 10p, 20p, 50p, £1, £2
* There should be a way of reloading products at a later point
* There should be a way of reloading change at a later point
* The machine should keep track of the products and change that it contains

## Setup
Ruby version used: ```2.7.2```
Clone the repository and cd into it, then run the following:
```
bundle install
```

## Testing
Testing is done using RSpec. To run tests, run
```
rspec
```

## Linting
Linting is done using Rubocop. To check for linting errors/warnings, run:
```
rubocop
```

## Running through IRB
If you'd like to run the program through IRB, run the following:
```
bundle exec irb -I lib -r ./lib/vending_machine.rb
```
You'll then be able to play around with it e.g.:

```
# initialise the vending machine and load in some initial products / coins
inventory = Inventory.new([
                              Product.new('Orange juice', 150, 100),
                              Product.new('Water', 100, 20),
                              Product.new('Cola', 200, 50),
                              Product.new('Apple Juice', 150, 0)
                            ])

coin_stack = CoinStack.new([
                              Coin.new(1, 1000),
                              Coin.new(2, 867),
                              Coin.new(5, 400),
                              Coin.new(10, 566),
                              Coin.new(20, 1000),
                              Coin.new(50, 500),
                              Coin.new(100, 1220),
                              Coin.new(200, 160)
                            ])
vm = VendingMachine.new(inventory, coin_stack)

# reload a product - (example increase Orange juice in the machine count by 10)
vm.reload_product('Orange juice', 10)

# reload a coin (example adds 1000 1p coins)
vm.reload_coin(1, 1000)

# insert some coins (£1.50 total in this example)
vm.insert_coin(50)
vm.insert_coin(100)

# purchase a product
vm.purchase_product('Orange juice')
```


## Overview
The below table shows a very quick overview of each file and what it's doing:
| type    | Name           | Purpose                                                                                                                                                          |
|---------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Class   | Coin           | Represents a coin *type* including its count.                                                                                                                    |
| Class   | CoinStack      | Essentially a container for our coins                                                                                                                            |
| Class   | Product        | Represents a product *type* including its count.                                                                                                                 |
| Class   | Inventory      | Essentially a container for our products                                                                                                                         |
| Class   | VendingMachine | This represents the vending machine itself, and is where the action happens e.g. inserting a coin, purchasing a product, reloading coins, reloading products etc |
| Class   | Messenger      | The messenger is used to print messages to the console (perhaps a bit overkill for our purposes, as all it really does is ```puts```)                            |
| Module  | Formatter      | Contains our constants; (which in our case is only our coin denominators)                                                                                        |
| Module  | Constants      | Contains a (rather basic) currency formatter which is used when we output messages                                                                               |
| Classes | errors.rb file | This is just where I've defined the custom errors used by the vending machine                                                                                    |

Note: I decided to represent money values throughout the app as penny integers (although any currency values printed to the console are passed through the formatter so it should show e.g. £1.00 for 100)

In ```VendingMachine.purchase_product``` you might be wondering why I've handled some of the errors a bit differently; my thinking here is that an ```InsufficientFundsError``` shouldn't cancel a transaction and eject coins, it should just ask for more money - whereas ```ExactChangeNotAvailableError```, ```ProductOutOfStockError``` and ```ProductNotAvailableError``` probably should cancel and eject.

## Things I'd improve given more time

## Products should have a unique ID
Rather than referencing products by name (string) it'd be better if I'd added a unique ID; it'd be a bit safer than relying on the exact string (I've put a couple of things in like converting to downcase symbols to make it more reliable but a better option would be IDs)

### Extra validation
There are some cases where we could do with some extra validation e.g. if we were to try to load initial products with a negative value, or a price of 0 (free) etc.

### Testing cleanup
Some of the testing could be done a bit better, the tests for ```purchase_product``` are testing the exact string output that is puts'd by our Messenger - this isn't great practise as if we ever need to change the message slightly we'll also need to update all our tests, but I did it this way for speed.

Some of the tests could do with more test cases.

### CoinStack/Coin coin reference names
On reflection, it might have been a better idea to refer to these as ```DenominatorStack/Denominator``` throughout our program; whilst the names I've been given are fine for our requirements, referring to them as Denomination would have meant if we ever wanted to add a feature to let the purchaser enter bank notes, all we'd need to do is update our ```COIN_DENOMINATORS``` constant with our new values.

### Shared functionality between ```CoinStack``` and ```Inventory```
The ```CoinStack``` and ```Inventory``` classes are very similar in nature, as they are essentially just containers for our coins/products. It might have been an idea to create a parent ```Container``` class and make them both inherit from it, putting any shared functionality in the parent.

### ```change_to_return``` algorithm
The ```change_to_return``` method's algorithm in our ```CoinStack``` class, which calculates which coins to return is not always going to be accurate (though it won't return incorrect change - it will eject the entered coins and cancel the transaction as the error is handled). The basic way in which it works is loop through all our coins, and 'fill' it with the first value that fits, starting from the highest. So it is theoretically possible that the algorithm will incorrectly fail, example scenario:

```
purchase price: £0.90
coins entered: £2.00
required_change: £1.10
£2 coins available: 10
£1 coins available: 1
50p coins available: 1
20p coins available: 3
10p coins available: 0
5p coins available: 0
2p coins available: 0
1p coins available: 0

Our algorithm in this scenario would behave as follows:
- Skip £2 coins because they are too big to fit within required_change
- Select our £1 coin to be returned
- Skip 50p coin as too big to fit in the remaining required_change
- Skip 20p coin as too big to fit in the remaining required_change
- Skip 10p, 5p, 2p, and 1p since there aren't any left
- raise a ExactChangeNotAvailableError, cancel the transaction and return the coins entered

Clearly though this would be incorrect, since exact change is achievable if we were to take 50p coin and 3 20p coins.
```


