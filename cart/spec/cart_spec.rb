require 'spec_helper'

RSpec.describe Cart do
  it 'queues items' do
    event_store = Rails.configuration.event_store
    event = CreateCart.new(
      data: {
        id: 'my-cart-id'
      }
    )
    event_store.publish(event)
  end
end
