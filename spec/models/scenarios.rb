# typed: true
require 'rails_helper'

class Scenarios
  extend T::Sig

  def self.optimistic_locking_scenario
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
  end

  sig {params(account_ids:T::Array[String], name_changes:T::Array[String]).returns(T::Array[AccountAggregate])}
  def self.bulk_example(account_ids, name_changes)
    client = RailsEventStore::Client.new
    repository = AggregateRoot::Repository.new

    account_ids.each{ |account_id|
      client.publish(AccountCreated.new(
        data: {
          id: account_id,
          name: ""
        }
      ), stream_name: account_id)
    }
    account_ids.each{|account_id|
      name_changes.each {|new_name|
        repository.with_aggregate(AccountAggregate.new, account_id) do |account|
          puts "changing name"
          account.changeName(new_name)
        end
      }
    }

    puts "loading end states"
    end_states =
      account_ids.map{|account_id|
        repository.load(AccountAggregate.new, account_id)
      }
    end_states
  end
end
