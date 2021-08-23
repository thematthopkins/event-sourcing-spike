require 'rails_helper'

class OrderHandler
  attr_accessor :events

  def initialize
    @events = []
  end

  def call(event)
    puts "called with event #{event}"
    events.append(event)
  end
end

RSpec.describe Order, type: :model do
  it 'calls subscribed notifications on event publication' do
    event_store = Rails.configuration.event_store
    orderHandler = OrderHandler.new
    event_store.subscribe(orderHandler, to: [CreateCart])
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    event_store.publish(event, stream_name: 'my-stream', expected_version: 10)
    expect(orderHandler.events)
      .to eq([event])
  end
end
