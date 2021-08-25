# typed: strict
require 'rails_helper'

class AccountCreated < RailsEventStore::Event
end
  

class AccountNameChanged < RailsEventStore::Event
end

class AccountAggregate
  include AggregateRoot

  attr_accessor :name
  attr_accessor :prev_name
  attr_accessor :id
  def initialize
  end

  def changeName(new_name)
    apply AccountNameChanged.new(data: {name: new_name, prev_name: @name})
  end

  on AccountNameChanged do |event|
    @name = event.data[:name]
    @prev_name = event.data[:prev_name]
  end

  on AccountCreated do |event|
    @name = event.data[:name]
    @id = event.data[:id]
  end
end


class AccountAggregate
  include AggregateRoot
end

RSpec.describe Account, type: :model do
  let (:client) { RailsEventStore::Client.new }

  let (:repository) { AggregateRoot::Repository.new }

  it 'can process name change events' do
    num_accounts = 100

    account_ids = (0...num_accounts).map{ |i| SecureRandom.uuid }
    account_ids.each{ |account_id|
      client.publish(AccountCreated.new(
        data: {
          id: account_id,
          name: ""
        }
      ), stream_name: account_id)
    }
    num_name_changes = 10
    name_changes = (0...num_name_changes).map{ |i| SecureRandom.uuid }

    account_ids.each{|account_id|
      name_changes.each {|new_name|
        repository.with_aggregate(AccountAggregate.new, account_id) do |account|
          account.changeName(new_name)
        end
      }
    }

    end_states =
      account_ids.map{|account_id|
        repository.load(AccountAggregate.new, account_id)
      }

    expect(end_states.length) .to eq(num_accounts)
    end_states.each_with_index {|account, i| 
      expect(account.id) .to eq(account_ids[i])
      expect(account.name) .to eq(name_changes[-1])
      expect(account.prev_name) .to eq(name_changes[-2])
    }
  end
end
