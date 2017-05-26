module TableBuilder
  class StringColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter string" do
        template.text_field_tag "filters[#{field}]", template.filters[field], class: "form-control input-sm filter string", title: "Use % as a wildcard to match any (partial) string", data: {toggle: "tooltip", placement: "bottom", html: "true"}
      end
    end

  end
end
