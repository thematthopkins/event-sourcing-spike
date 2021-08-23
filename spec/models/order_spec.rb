require 'rails_helper'
require 'carts_aggregate'

RSpec.describe Order, type: :model do
  let (:client) { client = Rails.configuration.event_store }
  it 'calls subscribed notifications on event publication' do
    CartsAggregate.new
    events_received = []
    client.subscribe(-> (event){
      events_received.append(event)
    }, to: [CreateCart])
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    client.publish(event, stream_name: 'my-stream', expected_version: 10)
    expect(events_received)
      .to eq([event])
  end

  it 'expected version conflicts to raise an exception' do
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    client.publish(event, stream_name: 'my-stream', expected_version: 0)

    expect(-> { client.publish(event, stream_name: 'my-stream', expected_version: 0) })
      .to raise_error(RubyEventStore::EventDuplicatedInStream)
  end

  it 'can read from a stream' do
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    client.publish(event, stream_name: 'my-stream', expected_version: 0)

    expect(client.read.stream('my-stream').count)
      .to eq(1)
  end

  it 'can create cart' do
    event = CreateCart.new(
      data: {
        cart_id: 'my-cart-id'
      }
    )
    client.publish(event, stream_name: 'my-stream', expected_version: 0)

    cartsAggregate = AggregateRoot::Repository.new.load(CartsAggregate.new, 'my-stream')
    expect(cartsAggregate.carts)
      .to eq({'my-cart-id'=> {
        :items => {}
      }})
  end

  it 'can create cart' do
    client.publish(CreateCart.new(
      data: {
        cart_id: 'my-cart-id'
      }
    ), stream_name: 'my-stream', expected_version: 0)

    cartsAggregate = AggregateRoot::Repository.new.load(CartsAggregate.new, 'my-stream')
    expect(cartsAggregate.carts)
      .to eq({'my-cart-id'=> {
        :items => {}
      }})
  end

  it 'throws exception when no cart' do
    client.publish(AddItem.new(
      data: {
        cart_id: 'my-cart-id'
      }
    ), stream_name: 'my-stream')
    expect(-> { AggregateRoot::Repository.new.load(CartsAggregate.new, 'my-stream') })
      .to raise_error(CartsAggregate::InvalidCartID)
  end

end
