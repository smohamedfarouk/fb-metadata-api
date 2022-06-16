class ComponentItemsController < ApplicationController
  def index
    render json: ComponentItemsSerialiser.new(items, service).attributes, status: :ok
  end

  def create
    if new_items.save
      render(
        json: ComponentItemsSerialiser.new(items, service).attributes,
        status: :created
      )
    else
      render json: ErrorsSerializer.new(
        message: service.errors.full_messages
      ).attributes, status: :unprocessable_entity
    end
  end

  private

  def items
    @items ||= Items.where(service_id: service.id)
  end

  def new_items
    @new_items ||= Items.new(items_params)
  end

  def items_params
    params.permit(:metadata)
    attributes = params[:metadata]

    if attributes
      {
        service_id: attributes[:service_id],
        component_id: params[:component_id],
        created_by: attributes[:created_by],
        data: attributes[:data]
      }
    else
      {
        service_id: nil,
        component_id: nil,
        created_by: nil,
        data: [{}]
      }
    end
  end
end
