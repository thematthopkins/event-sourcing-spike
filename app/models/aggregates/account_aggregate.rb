# typed: strict

class AccountCreated < RailsEventStore::Event
  extend T::Sig

  sig {params(msg: {data:{name: String, id: String}}).returns(AccountCreated)}
  def initialize(msg)
    super(msg)
  end
end
  
class AccountNameChanged < RailsEventStore::Event
end

class AccountNameChangeCompleted < RailsEventStore::Event
end

class AccountAggregate
  extend T::Sig
  include AggregateRoot

  # this is normally included via metaprogramming.  Sorbet requires the extra `extend` to set things staight
  extend AggregateRoot::OnDSL

  include AggregateRoot::AggregateMethods

  sig {returns(String)}
  attr_accessor :name

  sig {returns(String)}
  attr_accessor :prev_name

  sig {returns(String)}
  attr_accessor :id

  sig {void}
  def initialize()
    @name = T.let("", String)
    @prev_name = T.let("", String)
    @id = T.let("", String)
  end

  sig {params(new_name: String).void}
  def changeName(new_name)
    apply(AccountNameChanged.new(data: {name: new_name, prev_name: @name}))
  end

  on AccountNameChanged do |event|
    name = event.data[:name]
    prev_name = event.data[:prev_name]
  end

  on AccountCreated do |event|
    name = event.data[:name]
    id = event.data[:id]
  end

  on AccountNameChangeCompleted do |event|
  end
end

