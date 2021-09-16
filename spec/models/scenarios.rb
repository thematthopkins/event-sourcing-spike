# typed: true
require 'rails_helper'
require 'parallel'
require 'benchmark'

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

  sig {params(account_ids:T::Array[String], name_changes:T::Array[String], num_processes:Integer, batch_size: Integer).returns(T::Array[AccountAggregate])}
  def self.bulk_example_with_processes(account_ids, name_changes, num_processes, batch_size)
    split_ids = account_ids.each_slice(batch_size).to_a
    results = Parallel.map(split_ids, in_processes: num_processes) do |account_ids_for_process|
      self.bulk_example(account_ids_for_process, name_changes)
    end
    results.flatten
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
#        client.publish(AccountNameChanged.new(
#          data: {
#            name: new_name,
#            prev_name: new_name
#          }), stream_name: account_id)
        repository.with_aggregate(AccountAggregate.new, account_id) do |account|
          account.changeName(new_name)
        end
      }
    }

    end_states =
      account_ids.map{|account_id|
        repository.load(AccountAggregate.new, account_id)
      }
    end_states
  end
end
