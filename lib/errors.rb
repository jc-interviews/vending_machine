# frozen_string_literal: true

class ProductNotAvailableError < StandardError; end

class ProductOutOfStockError  < StandardError; end

class InsufficientFundsError  < StandardError; end

class ExactChangeNotAvailableError < StandardError; end

class CannotBeLessThanZeroError < StandardError; end
