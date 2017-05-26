module TableBuilder
  class DatetimeColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter datetime" do
        template.text_field_tag "filters[#{field}]", template.filters[field], class: "form-control input-sm filter datetime", data: {datetimerange: true}
      end
    end

    def default_body_html(record)
      I18n.localize record.send(field), format: (options[:format]||:long) rescue "-"
    end
  end
end
