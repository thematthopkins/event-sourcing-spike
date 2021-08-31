# typed: false
require 'rails_helper'
require_relative 'scenarios'

RSpec.describe Account, type: :model do
  extend T::Sig

  #T.cast(self, RSpec::Core::ExampleGroup)


  it 'optimistic locking works with different event counts' do
    expect {
      Scenarios.optimistic_locking_scenario
    }.to raise_exception(RubyEventStore::WrongExpectedEventVersion)
  end

  it 'can process bulk name change events' do
    num_accounts = 1
    account_ids = (0...num_accounts).map{ |i| SecureRandom.uuid }
    num_name_changes = 100
    name_changes = (0...num_name_changes).map{ |i| SecureRandom.uuid }

    end_states = Scenarios.bulk_example(account_ids, name_changes)
    expect(end_states.length) .to eq(num_accounts)
    end_states.each_with_index {|account, i| 
      puts "result id #{account.id}"
      expect(account.id) .to eq(account_ids[i])
      expect(account.name) .to eq(name_changes[-1])
      expect(account.prev_name) .to eq(name_changes[-2])
    }
  end
end
