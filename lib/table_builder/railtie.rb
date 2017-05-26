require 'table_builder/helpers'

module TableBuilder
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << TableBuilder

    initializer 'table_builder.helper' do |app|
      ActionView::Base.send :include, TableBuilder::Helpers
    end
  end
end
