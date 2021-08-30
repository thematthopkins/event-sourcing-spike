# typed: false
require 'rails_helper'

RSpec.describe Account, type: :model do
  puts(self.method(:it).source_location)
  it 'optimistic locking works with different event counts' do
    expect {
      repository = AggregateRoot::Repository.new
      account_id = '1'
      t = Thread.new do
        repository.with_aggregate(AccountAggregate.new, account_id) do |account|
          sleep 0.1
          account.changeName('b')
        end
      end


      repository.with_aggregate(AccountAggregate.new, account_id) do |account|
        sleep 1
        account.changeNameWith2Events('a')
      end
      t.join
    }.to raise_exception(RubyEventStore::WrongExpectedEventVersion)
  end

  it 'can process bulk name change events' do
    num_accounts = 1
    client = RailsEventStore::Client.new
    repository = AggregateRoot::Repository.new

    account_ids = (0...num_accounts).map{ |i| SecureRandom.uuid }
    account_ids.each{ |account_id|
      client.publish(AccountCreated.new(
        data: {
          id: account_id,
          name: ""
        }
      ), stream_name: account_id)
    }
    num_name_changes = 20
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
