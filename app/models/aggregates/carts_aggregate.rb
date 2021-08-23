class SetShippingAddress < RailsEventStore::Event
end

class RemoveItem < RailsEventStore::Event
end

class CreateCart < RailsEventStore::Event
end

class AddItem < RailsEventStore::Event
end

class CartsAggregate
  include AggregateRoot
  class HasNoMoreItemsToRemove < StandardError; end
  class InvalidCartID < StandardError; end

  attr_accessor :carts

  def initialize
    @carts = {}
  end

  on SetShippingAddress do |event|
  end

  on RemoveItem do |event|
  end

  on CreateCart do |event|
    carts[event.data[:cart_id]] = {:items => {}}
  end

  on AddItem do |event|
    raise InvalidCartID unless @carts.has_key?(event.data[:cart_id]) 
  end
end

