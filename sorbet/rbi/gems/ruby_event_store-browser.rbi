# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ruby_event_store-browser/all/ruby_event_store-browser.rbi
#
# ruby_event_store-browser-2.2.0

module RubyEventStore
end
module RubyEventStore::Browser
end
class RubyEventStore::Browser::Event
  def as_json; end
  def event; end
  def event_id; end
  def event_store; end
  def initialize(event_store:, params:); end
  def params; end
  def parent_event_id; end
end
class RubyEventStore::Browser::JsonApiEvent
  def causation_stream_name; end
  def correlation_stream_name; end
  def event; end
  def initialize(event, parent_event_id); end
  def metadata; end
  def parent_event_id; end
  def to_h; end
  def type_stream_name; end
end
class RubyEventStore::Browser::GetEventsFromStream
  def as_json; end
  def count; end
  def direction; end
  def event_store; end
  def events; end
  def events_backward(position); end
  def events_forward(position); end
  def first_page_link; end
  def initialize(event_store:, params:, routing:); end
  def last_page_link; end
  def links; end
  def next_event?; end
  def next_page_link(event_id); end
  def pagination_param; end
  def params; end
  def position; end
  def prev_event?; end
  def prev_page_link(event_id); end
  def routing; end
  def stream_name; end
end
class RubyEventStore::Browser::GetStream
  def as_json; end
  def initialize(routing:, stream_name:, related_streams_query:); end
  def related_streams; end
  def related_streams_query; end
  def routing; end
  def stream_name; end
end
class RubyEventStore::Browser::Routing
  def api_url; end
  def base_url; end
  def events_url; end
  def host; end
  def initialize(host, root_path); end
  def paginated_events_from_stream_url(id:, position: nil, direction: nil, count: nil); end
  def root_path; end
  def root_url; end
  def streams_url; end
end
class RubyEventStore::Browser::App < Sinatra::Base
  def json(data); end
  def routing; end
  def self.api_url; end
  def self.api_url=(val); end
  def self.api_url?; end
  def self.app_file; end
  def self.app_file=(val); end
  def self.app_file?; end
  def self.event_store_locator; end
  def self.event_store_locator=(val); end
  def self.event_store_locator?; end
  def self.for(event_store_locator:, host: nil, path: nil, api_url: nil, environment: nil, related_streams_query: nil); end
  def self.host; end
  def self.host=(val); end
  def self.host?; end
  def self.protection; end
  def self.protection=(val); end
  def self.protection?; end
  def self.related_streams_query; end
  def self.related_streams_query=(val); end
  def self.related_streams_query?; end
  def self.root_path; end
  def self.root_path=(val); end
  def self.root_path?; end
  def symbolized_params; end
end
