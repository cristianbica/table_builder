module TableBuilder
  class ActionsColumn < Column

    self.default_options = {
      sortable: false,
      filtrable: false,
      width: 10
    }

    def header_cell_html
      content_tag :th, header_html_attributes do
        ""
      end
    end

    def default_body_html(record)
      actions = options[:actions]
      html = []
      html << link_to("Edit", url_for(controller: template.params[:controller], action: :edit, id: record.id)) if actions.include?(:edit)
      html << link_to("Delete", url_for(controller: template.params[:controller], action: :destroy, id: record.id),
                                           remote: true, method: :delete, data: {confirm: "Are you sure?"})  if actions.include?(:destroy)
      html << link_to("Deactivate", url_for(controller: template.params[:controller], action: :destroy, id: record.id),
                                           remote: true, method: :delete,
                                           data: {confirm: "Are you sure you want to deactivate this customer and cancel all his services?"})  if actions.include?(:deactivate)

      html.join(" ").html_safe
    end
  end
end
