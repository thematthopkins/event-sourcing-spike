# typed: strict
require 'rails_helper'
require 'benchmark'


class AccountCreated < RailsEventStore::Event
  sig {params(msg: {data:{name: String, id: String}}).returns(AccountCreated)}
  def initialize(msg)
    base(msg)
  end
end
  
class AccountNameChanged < RailsEventStore::Event
end

class AccountNameChangeCompleted < RailsEventStore::Event
end

class AccountAggregate
  include AggregateRoot

  attr_accessor :name
  attr_accessor :prev_name
  attr_accessor :id
  def initialize
  end

  def changeName(new_name)
    apply(AccountNameChanged.new(data: {name: new_name, prev_name: @name}))
  end

  def changeName2(new_name)
    apply(AccountNameChanged.new(data: {name: new_name, prev_name: @name}), AccountNameChangeCompleted.new())
  end

  on AccountNameChanged do |event|
    @name = event.data[:name]
    @prev_name = event.data[:prev_name]
  end

  on AccountCreated do |event|
    @name = event.data[:name]
    @id = event.data[:id]
  end

  on AccountNameChangeCompleted do |event|
  end
end


RSpec.describe Account, type: :model do
  let (:client) { RailsEventStore::Client.new }

  let (:repository) { AggregateRoot::Repository.new }

  it 'optimistic locking works with different event counts' do
    expect {
      account_id = '1'
      t = Thread.new do
        repository.with_aggregate(AccountAggregate.new, account_id) do |account|
          puts 'changine name b'
          sleep 0.1
          account.changeName('b')
          puts 'changed name b'
        end
      end


      repository.with_aggregate(AccountAggregate.new, account_id) do |account|
        puts 'changine name a'
        sleep 1
        account.changeName2('a')
        puts 'changed name a'
      end

      puts 'waiting'
      t.join
    }.to raise_exception(RubyEventStore::WrongExpectedEventVersion)
  end

  it 'can process bulk name change events' do
    num_accounts = 1

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

    time = Benchmark.measure {

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
    }
    puts "projection time: #{time.real}"
  end
end
