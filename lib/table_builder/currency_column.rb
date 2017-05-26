module TableBuilder
  class CurrencyColumn < IntegerColumn
    def default_body_html(record)
      template.number_to_currency record.send(field).to_f
    end
  end
end
