module TableBuilder
  class Column
    class_attribute :default_options
    self.default_options = {
      sortable: true,
      filtrable: false
    }

    attr_accessor :builder, :template, :field, :options, :block, :original_options
    delegate :content_tag, :link_to, :url_for, to: :template

    def initialize(builder, template, field, options={}, &block)
      self.builder = builder
      self.template = template
      self.field = field
      self.options = default_options.dup.merge options
      self.block = block
    end

    def default_options
      self.class.default_options
    end

    def sortable?
      !!options[:sortable]
    end

    def sorting?
      template.params[:sort_by].present? and template.params[:sort_by]==self.sorting_field.to_s
    end

    def sorting_dir
      template.params[:sort_dir]
    end

    def inverse_sorting_dir
      sorting_dir.to_s.downcase == 'asc' ? 'desc' : 'asc'
    end

    def sorting_field
      options[:sorting_field] || default_sorting_field
    end

    def default_sorting_field
      [builder.collection.model.table_name, self.field.to_s].join(".")
    rescue
      self.field.to_s
    end

    def sorting_params
      {
        sort_by: sorting_field,
        sort_dir: sorting? ? inverse_sorting_dir : "asc"
      }
    end

    def filtrable?
      !!options[:filtrable]
    end

    def field_label
      options[:label] || (field==:id ? "ID" : field.to_s.humanize)
    end

    def header_css_classes
      classes = []
      classes << "#{field}-field"
      classes << :sorting if sortable?
      classes << "sorting_#{sorting_dir}" if sorting?
      classes << "text-#{options[:align]}" if options[:align].present?
      classes << column_css_class
      classes += options[:header_html][:class].to_s.split(" ")
      classes.join " "
    end

    def header_html_attributes
      options[:header_html] ||= {}
      options[:header_html][:class] = header_css_classes
      options[:header_html][:width] = options[:width] if options[:width].present?
      options[:header_html]
    end

    def column_css_class
      self.class.name.demodulize.underscore.gsub("_column","")
    end

    def header_cell_html
      content_tag :th, header_html_attributes do
        if sortable?
          link_to field_label, url_for(template.params.merge(sorting_params))
        else
          field_label.html_safe
        end
      end
    end

    def header_filter_cell_html
      content_tag :th, class: "filter" do
        ""
      end
    end

    def css_classes
      classes = []
      classes << field
      classes << "text-#{options[:align]}" if options[:align].present?
      classes.join " "
    end

    def html_attributes
      options[:html] ||= {}
      options[:html][:class] = (options[:html][:class].to_s + header_css_classes).split(" ").uniq.join(" ")
      options[:html]
    end

    def body_cell_html(record)
      content_tag :td, html_attributes do
        block.present? ? block.call(record) : default_body_html(record)
      end
    end

    def default_body_html(record)
      record.send(field).to_s
    end

    def determine_namespace
      parts = template.params[:controller].split("/")
      parts.size > 0 ? parts.first : nil
    end
  end
end
