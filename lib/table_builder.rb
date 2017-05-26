require "table_builder/version"

module TableBuilder
  extend ActiveSupport::Autoload

  autoload :ActionsColumn
  autoload :BelongsToColumn
  autoload :BooleanColumn
  autoload :Column
  autoload :CurrencyColumn
  autoload :DateColumn
  autoload :DatetimeColumn
  autoload :EnumColumn
  autoload :HasManyColumn
  autoload :Helper
  autoload :IntegerColumn
  autoload :StringColumn
  autoload :Table
  autoload :TextColumn
end

if defined? Rails
  require 'table_builder/railtie'
  require 'table_builder/engine'
end
