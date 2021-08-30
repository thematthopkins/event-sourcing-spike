# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/activerecord-import/all/activerecord-import.rbi
#
# activerecord-import-1.2.0

module ActiveRecord::Import::ConnectionAdapters
end
module ActiveRecord::Import
  def self.base_adapter(adapter); end
  def self.load_from_connection_pool(connection_pool); end
  def self.require_adapter(adapter); end
end
class ActiveRecord::Import::Result < Struct
  def failed_instances; end
  def failed_instances=(_); end
  def ids; end
  def ids=(_); end
  def num_inserts; end
  def num_inserts=(_); end
  def results; end
  def results=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
end
module ActiveRecord::Import::ImportSupport
  def supports_import?; end
end
module ActiveRecord::Import::OnDuplicateKeyUpdateSupport
  def supports_on_duplicate_key_update?; end
end
class ActiveRecord::Import::MissingColumnError < StandardError
  def initialize(name, index); end
end
class ActiveRecord::Import::Validator
  def init_validations(klass); end
  def initialize(klass, options = nil); end
  def valid_model?(model); end
end
class ActiveRecord::Associations::CollectionProxy < ActiveRecord::Relation
  def bulk_import(*args, &block); end
  def import(*args, &block); end
end
class ActiveRecord::Associations::CollectionAssociation < ActiveRecord::Associations::Association
  def bulk_import(*args, &block); end
  def import(*args, &block); end
end
module ActiveRecord::Import::Connection
  def establish_connection(args = nil); end
end
class ActiveRecord::Base
  def synchronize(instances, key = nil); end
end
module ActiveRecord::Import::AbstractAdapter
end
module ActiveRecord::Import::AbstractAdapter::InstanceMethods
  def after_import_synchronize(instances); end
  def increment_locking_column!(table_name, results, locking_column); end
  def insert_many(sql, values, _options = nil, *args); end
  def next_value_for_sequence(sequence_name); end
  def post_sql_statements(table_name, options); end
  def pre_sql_statements(options); end
  def supports_on_duplicate_key_update?; end
end
module ActiveRecord
end
module ActiveRecord::ConnectionAdapters
end
class ActiveRecord::ConnectionAdapters::AbstractAdapter
  include ActiveRecord::Import::AbstractAdapter::InstanceMethods
end
class ActiveRecord::Import::ValueSetTooLargeError < StandardError
  def initialize(msg = nil, size = nil); end
  def size; end
end
class ActiveRecord::Import::ValueSetsBytesParser
  def default_max_bytes; end
  def initialize(values, options); end
  def max_bytes; end
  def parse; end
  def reserved_bytes; end
  def self.parse(values, options); end
  def values; end
end
class ActiveRecord::Import::ValueSetsRecordsParser
  def initialize(values, options); end
  def max_records; end
  def parse; end
  def self.parse(values, options); end
  def values; end
end
module ActiveRecord::Import::PostgreSQLAdapter
  def add_column_for_on_duplicate_key_update(column, options = nil); end
  def database_version; end
  def duplicate_key_update_error?(exception); end
  def insert_many(sql, values, options = nil, *args); end
  def next_value_for_sequence(sequence_name); end
  def post_sql_statements(table_name, options); end
  def returning_columns(options); end
  def split_ids_and_results(values, columns, options); end
  def sql_for_conflict_target(args = nil); end
  def sql_for_default_conflict_target(table_name, primary_key); end
  def sql_for_on_duplicate_key_ignore(table_name, *args); end
  def sql_for_on_duplicate_key_update(table_name, *args); end
  def sql_for_on_duplicate_key_update_as_array(table_name, locking_column, arr); end
  def sql_for_on_duplicate_key_update_as_hash(table_name, locking_column, hsh); end
  def supports_on_duplicate_key_update?; end
  def supports_setting_primary_key_of_imported_objects?; end
  include ActiveRecord::Import::ImportSupport
  include ActiveRecord::Import::OnDuplicateKeyUpdateSupport
end
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
  include ActiveRecord::Import::PostgreSQLAdapter
end
