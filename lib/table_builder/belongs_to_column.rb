module TableBuilder
  class BelongsToColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true,
      display_field: :name
    }

    def header_filter_cell_html
      namespace = options.delete(:namespace) || determine_namespace
      filter_field_name = builder.collection.model.reflect_on_association(field).foreign_key
      selected_id = template.filters[filter_field_name]
      if selected_id.present?
        selected_object = builder.collection.model.reflect_on_association(field).klass.find_by(id: selected_id)
        selected_option = template.options_for_select({selected_object.name => selected_object.id}, selected_object.id)
      else
        selected_option = nil
      end
      content_tag :th, class: "filter belongs-to" do
        template.select_tag "filters[#{filter_field_name}]", selected_option,
                            class: "form-control input-sm filter belongs-to", include_blank: true,
                              data: {
                                placeholder: "Search ...",
                                "allow-clear" => true,
                                ajax: {
                                  url: options[:filtrable_url] || template.polymorphic_path([namespace, builder.collection.model.reflect_on_association(field).klass], format: :json),
                                  cache: true
                                }
                              }
      end
    end

    def initialize(builder, template, field, opts={}, &block)
      super
      options[:sorting_field] ||= [builder.collection.model.reflect_on_association(field).klass.table_name, options[:display_field]].join(".")
    end

    def default_body_html(parent)
      namespace = options.delete(:namespace) || determine_namespace
      record = parent.send(field)
      record.send(options[:display_field])
    rescue
      "-"
      # url = template.polymorphic_path [namespace, record] rescue nil
      # if url
      #   link_to record.send(options[:display_field]), url
      # else
      #   record.send(options[:display_field])
      # end
    end
  end
end
