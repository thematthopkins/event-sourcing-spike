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


  let(:repo){AggregateRoot::Repository.new}

  def runNameChanges(account_id, count)
    client = RailsEventStore::Client.new

    account_id = 'my-account-id'
    client.publish(AccountCreated.new(
      data: {
        id: account_id,
        name: ""
      }
    ), stream_name: account_id)

    name_changes = (0..count).map{ |i| SecureRandom.uuid }
    name_changes.each {|new_name|
      repo.with_aggregate(AccountAggregate.new, account_id) do |account|
            account.changeName(new_name)
      end
    }

  end

  it 'drops the created event when there are 100 events' do
    runNameChanges('my-account-id', 100)
    result = repo.load(AccountAggregate.new, 'my-account-id')
    expect(result.id).to eq('')
  end

  it 'retains the created event when there are < 50 events' do
    runNameChanges('my-account-id', 50)
    result = repo.load(AccountAggregate.new,  'my-account-id')
    expect(result.id).to eq('my-account-id')
  end
end
