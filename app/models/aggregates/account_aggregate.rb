# typed: strict

class AccountCreated < RailsEventStore::Event
  extend T::Sig

  sig {params(event_id: String, metadata: T.nilable(T::Hash[String, String]), data:{name: String, id: String}).void}
  def initialize(event_id: SecureRandom.uuid, metadata: nil, data: {name: "", id: ""})
    super(event_id: event_id, metadata: metadata, data: data)
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

  sig {params(new_name: String).void}
  def changeNameWith2Events(new_name)
    apply(AccountNameChanged.new(data: {name: new_name, prev_name: @name}), AccountNameChangeCompleted.new())
  end

  on AccountNameChanged do |event|
    T.bind(self, AccountAggregate)
    #sorbet doesn't like using @ field names here
    self.name = event.data[:name]
    self.prev_name = event.data[:prev_name]
  end

  on AccountCreated do |event|
    T.bind(self, AccountAggregate)
    self.name = event.data[:name]
    self.id = event.data[:id]
  end

  on AccountNameChangeCompleted do |event|
  end
end

