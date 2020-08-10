class BaseSerializer
  def initialize(object)
    @object = object
  end

  def as_json(_options = {})
    raise 'Base class called. Method as_json must be implemented.'
  end

  def collection_as_json
    return [] unless @object.is_a?(Enumerable)

    @object.map do |item|
      as_json(item)
    end
  end
end
