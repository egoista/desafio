class V1::StoresSerializer < BaseSerializer
  def as_json(_options = {})
    {
      id: @object.id,
      name: @object.name,
      address: @object.address,
      stock_items: V1::StockItemsSerializer.collection_as_json(@object.stock_items)
    }.as_json
  end
end
