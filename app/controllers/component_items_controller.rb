class ComponentItemsController < ApplicationController
  before_action :validate_items, only: :create

  def index
    render json: ComponentItemsSerialiser.new(service.items, params[:service_id]).attributes, status: :ok
  end

  def create
    if new_items.save
      render json: { message: 'Created' }, status: :created
    else
      render json: ErrorsSerializer.new(
        message: new_items.errors.full_messages
      ).attributes, status: :unprocessable_entity
    end
  end

  private

  def new_items
    @new_items ||= Items.new(items_params)
  end

  def items_params
    params.permit(:service_id, :component_id, :created_by, data: %i[text value])
  end

  def validate_items
    MetadataPresenter::ValidateSchema.validate(params[:data], 'definition.select')
  rescue JSON::Schema::ValidationError, JSON::Schema::SchemaError, SchemaNotFoundError => e
    render(
      json: ErrorsSerializer.new(message: e.message).attributes,
      status: :unprocessable_entity
    )
  end
end
