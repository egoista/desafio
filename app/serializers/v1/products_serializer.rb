class V1::ProductsSerializer < BaseSerializer
  def as_json(_options = {})
    {
      id: @object.id,
      name: @object.name,
      price: @object.price
    }.as_json
  end
end
