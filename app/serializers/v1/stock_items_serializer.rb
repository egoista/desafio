class V1::StockItemsSerializer < BaseSerializer
  def as_json(_options = {})
    {
      product_id: @object.product_id,
      quantity: @object.quantity
    }.as_json
  end
end
