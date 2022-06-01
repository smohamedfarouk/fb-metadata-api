class ComponentItemsSerialiser
  attr_accessor :items, :service

  def initialize(items, service)
    @items = items
    @service = service
  end

  def attributes
    {
      service_id: service.id,
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
