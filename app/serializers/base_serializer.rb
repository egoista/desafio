class BaseSerializer
  def initialize(object)
    @object = object
  end

  def as_json(_options = {})
    raise 'Base class called. Method as_json must be implemented.'
  end

  def self.collection_as_json(collection)
    return [] unless collection.is_a?(Enumerable)

    collection.map do |item|
      new(item).as_json
    end
  end
end
