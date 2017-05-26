module TableBuilder
  class IntegerColumn < Column

    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter integer" do
        template.text_field_tag "filters[#{field}]", template.filters[field], class: "form-control input-sm filter integer", title: "Examples:<br/>&gt;1<br>&gt;=1<br/>&lt;100<br/>&lt;=100<br/>1,2,3,4,10,15,65<br/>1..5  (this means 1,2,3,4,5)", data: {toggle: "tooltip", placement: "bottom", html: "true"}
      end
    end

  end
end
