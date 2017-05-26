module TableBuilder
  class EnumColumn < Column
    self.default_options = {
      sortable: true,
      filtrable: true
    }

    def header_filter_cell_html
      content_tag :th, class: "filter enum" do
        template.select_tag "filters[#{field}]", template.options_for_select(builder.collection.model.defined_enums[field.to_s], template.filters[field]),
                            class: "form-control input-sm filter enum select2", include_blank: true,
                              data: {
                                placeholder: "Select ...",
                                "allow-clear" => true,
                                "minimum-results-for-search" => 99999
                              }
      end
    end
  end
end
