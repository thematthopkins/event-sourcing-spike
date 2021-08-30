# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/aggregate_root/all/aggregate_root.rbi
#
# aggregate_root-2.2.0

module AggregateRoot
  def self.configuration; end
  def self.configuration=(arg0); end
  def self.configure; end
  def self.included(host_class); end
  def self.with_default_apply_strategy; end
  def self.with_strategy(strategy); end
end
class AggregateRoot::Configuration
  def default_event_store; end
  def default_event_store=(arg0); end
end
class AggregateRoot::Transform
  def self.to_snake_case(name); end
end
class AggregateRoot::MissingHandler < StandardError
end
class AggregateRoot::DefaultApplyStrategy
  def apply_handler_name(event_type); end
  def call(aggregate, event); end
  def event_type(event_type); end
  def handler_name(aggregate, event); end
  def initialize(strict: nil); end
  def on_dsl_handler_name(aggregate, event_type); end
  def on_methods; end
  def strict; end
end
class AggregateRoot::Repository
  def default_event_store; end
  def event_store; end
  def initialize(event_store = nil); end
  def load(aggregate, stream_name); end
  def store(aggregate, stream_name); end
  def with_aggregate(aggregate, stream_name, &block); end
end
class AggregateRoot::InstrumentedRepository
  def initialize(repository, instrumentation); end
  def instrumentation; end
  def load(aggregate, stream_name); end
  def repository; end
  def store(aggregate, stream_name); end
  def with_aggregate(aggregate, stream_name, &block); end
end
module AggregateRoot::OnDSL
  def on(*event_klasses, &block); end
  def on_methods; end
end
module AggregateRoot::Constructor
  def new(*arg0); end
end
module AggregateRoot::AggregateMethods
  def apply(*events); end
  def unpublished_events; end
  def version; end
  def version=(value); end
end
