class ComponentItemsController < ApplicationController
  def index
    render json: ComponentItemsSerialiser.new(items, service).attributes, status: :ok
  end

  private

  def service
    @service ||= Service.find(params[:service_id])
  end

  def items
    @items ||= Items.where(service_id: service.id)
  end
end
