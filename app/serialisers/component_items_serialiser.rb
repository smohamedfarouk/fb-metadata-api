class ComponentItemsSerialiser
  attr_accessor :items, :service_id

  def initialize(items, service_id)
    @items = items
    @service_id = service_id
  end

  def attributes
    {
      service_id: service_id,
      items: all_items
    }
  end
end

private

def all_items
  items.map do |item|
    { item.component_id => item.data }
  end
end
