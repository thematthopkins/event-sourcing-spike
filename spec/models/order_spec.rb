require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'calls subscribed notifications on event publication' do
    event_store = Rails.configuration.event_store
    events_received = []
    event_store.subscribe(-> (event){
      events_received.append(event)
    }, to: [CreateCart])
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    event_store.publish(event, stream_name: 'my-stream', expected_version: 10)
    expect(events_received)
      .to eq([event])
  end
end
