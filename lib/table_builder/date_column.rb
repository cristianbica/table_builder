module TableBuilder
  class DateColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter date" do
        template.text_field_tag "filters[#{field}]", template.filters[field], class: "form-control input-sm filter date", data: {daterange: true}
      end
    end

    def default_body_html(record)
      I18n.localize record.send(field).to_date, format: (options[:format]||:long) rescue "-"
    end
  end
end
