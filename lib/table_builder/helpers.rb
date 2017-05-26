module TableBuilder
  module Helpers
    def table_for(collection, options={}, &block)
      Table.new(self, collection, options, &block).to_html
    end
  end
end
