module TableBuilder
  class Table
    DEFAULT_OPTIONS = {searchable: true, paginate: true}

    attr_accessor :collection, :options, :template, :columns, :subtitle
    delegate :content_tag, :link_to, :url_for, to: :template

    def initialize(template, collection, options={}, &block)
      self.template = template
      self.collection = collection
      self.options = DEFAULT_OPTIONS.dup.merge options
      self.columns = []
      template.content_for(:title, (options[:title] || collection.model.model_name.human.pluralize), flush: true)
      @collection_actions = nil
      block.call(self)
    end

    def column(field, options={}, &block)
      columns << column_class(field, options).new(self, template, field, options, &block)
    end

    def has_many(field, options={}, &block)
      columns << HasManyColumn.new(self, template, field, options, &block)
    end

    def belongs_to(field, options={}, &block)
      columns << BelongsToColumn.new(self, template, field, options, &block)
    end

    def actions(actions = [:edit, :destroy], options={}, &block)
      options[:actions] = actions.is_a?(Array) ? actions : (options[:actions]||[:edit, :destroy])
      columns << ActionsColumn.new(self, template, :actions, options, &block) if options[:actions].size>0 or block
    end

    def title(title=nil)
      if title
        template.content_for(:title, title, flush: true)
      else
        template.content_for(:title)
      end
    end

    def subtitle(subtitle=nil, &block)
      if block
        @subtitle = template.capture do
          template.instance_eval(&block)
        end
      elsif subtitle
        @subtitle = subtitle
      else
        @subtitle
      end
    end

    def collection_action(action = nil, &block)
      @collection_actions ||= []
      if block
        @collection_actions << template.capture do
          template.instance_eval(&block)
        end
      elsif action
        @collection_actions << action
      end
    end

    def collection_actions(actions = nil)
      if actions
        @collection_actions = actions
      else
        @collection_actions || [:add]
      end

    end

    def to_html
      template.render partial: "table_builder/table", locals: {table: self}
    end

    def build_table
      content_tag :table, (options[:html]||{}).merge(class: options[:class]) do
        build_head + build_body
      end.html_safe
    end

    def build_head
      content_tag :thead do
        html = content_tag :tr do
          columns.map(&:header_cell_html).join("").html_safe
        end
        html += content_tag :tr, class: "table-filters" do
          columns.map do |column|
            if column.filtrable?
              column.header_filter_cell_html
            else
              content_tag :th, class: "filter" do
                ""
              end
            end
          end.join("").html_safe
        end if options[:searchable] and columns.any?(&:filtrable?)
        html.html_safe
      end
    end

    def build_body
      content_tag :tbody do
        collection.map do |record|
          content_tag :tr do
            columns.map do |column|
              column.body_cell_html(record)
            end.join("").html_safe
          end
        end.join("").html_safe
      end
    end

    protected
      def column_class(field, options)
        type = nil
        type = :enum if collection.model.defined_enums.key?(field.to_s)
        type ||= options.delete(:as)
        type ||= collection.model.columns_hash[field.to_s].try(:type)
        TableBuilder.const_get([type, :column].compact.join("_").classify)
      rescue Exception => e
        TableBuilder::Column
      end
  end
end
