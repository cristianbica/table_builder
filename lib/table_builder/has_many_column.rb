module TableBuilder
  class HasManyColumn < Column
    self.default_options = {
      sortable: false,
      filtrable: false,
      align: :center,
      width: 10
    }

    def default_options
      opts = super
      opts[:sortable] = true if builder.collection.model.column_names.include?("#{field}_count")
      opts[:filtrable] = true if builder.collection.model.column_names.include?("#{field}_count")
      opts
    end

    def sorting_field
      [builder.collection.model.table_name, "#{field}_count"].join(".")
    end

    def filtering_field
      "#{field}_count"
    end

    def header_filter_cell_html
      content_tag :th, class: "filter integer" do
        template.text_field_tag "filters[#{filtering_field}]", template.filters[filtering_field], class: "form-control input-sm filter integer", title: "Examples:<br/>&gt;1<br>&gt;=1<br/>&lt;100<br/>&lt;=100<br/>1,2,3,4,10,15,65<br/>1..5  (this means 1,2,3,4,5)", data: {toggle: "tooltip", placement: "bottom", html: "true"}
      end
    end

    def default_body_html(record)
      namespace = options.delete(:namespace) || determine_namespace
      url = options.delete(:url)
      #url ||= template.polymorphic_path [namespace, record, field].flatten.compact rescue nil
      url ||= template.polymorphic_path [namespace, record, record.send(field).model].flatten.compact rescue nil
      url ||= template.polymorphic_path [namespace, record, "#{record.class.name.underscore}_#{field}"].flatten.compact rescue '#'
      if record.respond_to?(:"#{field}_count")
        link_to record.send(:"#{field}_count").to_i, url
      else
        link_to record.send(field).count, url
      end
    end
  end
end
