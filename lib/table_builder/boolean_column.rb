module TableBuilder
  class BooleanColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter boolean" do
        template.select_tag "filters[#{field}]", template.options_for_select({"YES" => true, 'NO' => false}, template.filters[field]),
                            class: "form-control input-sm filter enum select2", include_blank: true,
                              data: {
                                placeholder: "Select ...",
                                "allow-clear" => true,
                                "minimum-results-for-search" => 99999
                              }
      end
    end

    def default_body_html(record)
      !!record.send(field) ? "YES" : "NO"
    end
  end
end
