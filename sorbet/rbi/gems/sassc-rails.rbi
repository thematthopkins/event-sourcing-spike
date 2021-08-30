# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/sassc-rails/all/sassc-rails.rbi
#
# sassc-rails-2.1.2

module SassC
end
module SassC::Rails
end
module Sprockets
end
module Sprockets::SassProcessor::Functions
end
module SassC::Script::Functions
  include Sprockets::SassProcessor::Functions
end
class SassC::Rails::Importer < SassC::Importer
  def context; end
  def extension_for_file(file); end
  def glob_imports(base, glob, current_file); end
  def globbed_files(base, glob); end
  def imports(path, parent_path); end
  def load_paths; end
  def record_import_as_dependency(path); end
end
class SassC::Rails::Importer::Extension
  def import_for(full_path, parent_dir, options); end
  def initialize(postfix = nil); end
  def postfix; end
end
class SassC::Rails::Importer::CSSExtension
  def import_for(full_path, parent_dir, options); end
  def postfix; end
end
class SassC::Rails::Importer::CssScssExtension < SassC::Rails::Importer::Extension
  def import_for(full_path, parent_dir, options); end
  def postfix; end
end
class SassC::Rails::Importer::CssSassExtension < SassC::Rails::Importer::Extension
  def import_for(full_path, parent_dir, options); end
  def postfix; end
end
class SassC::Rails::Importer::SassERBExtension < SassC::Rails::Importer::Extension
  def import_for(full_path, parent_dir, options); end
  def postfix; end
end
class SassC::Rails::Importer::ERBExtension < SassC::Rails::Importer::Extension
  def import_for(full_path, parent_dir, options); end
end
class SassC::Rails::SassTemplate < Sprockets::SassProcessor
  def call(input); end
  def config_options; end
  def initialize(options = nil, &block); end
  def line_comments?; end
  def load_paths; end
  def safe_merge(_key, left, right); end
  def sass_style; end
end
module SassC::Rails::SassTemplate::Functions
  def asset_data_url(path); end
  def asset_path(path, options = nil); end
  def asset_url(path, options = nil); end
end
class SassC::Rails::ScssTemplate < SassC::Rails::SassTemplate
  def self.syntax; end
end
class Sprockets::SassCompressor
  def evaluate(*args); end
end
class SassC::Rails::Railtie < Rails::Railtie
end
