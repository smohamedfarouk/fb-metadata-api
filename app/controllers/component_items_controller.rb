class ComponentItemsController < ApplicationController
  before_action :validate_items, only: :create

  def index
    render json: ComponentItemsSerialiser.new(existing_component_items, params[:service_id]).attributes, status: :ok
  end

  def show
    if component_items.any?
      render json: ComponentItemsSerialiser.new(component_items, params[:service_id]).attributes, status: :ok
    else
      render json: ErrorsSerializer.new(
        message: "Component with id: #{params[:component_id]} has no items"
      ).attributes, status: :not_found
    end
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
    @items_params ||= params.permit(:service_id, :component_id, :created_by, data: %i[text value])
  end

  def validate_items
    MetadataPresenter::ValidateSchema.validate(
      items_params.to_h['data'],
      'definition.select'
    )
  rescue JSON::Schema::ValidationError, JSON::Schema::SchemaError, SchemaNotFoundError => e
    render(
      json: ErrorsSerializer.new(message: e.message).attributes,
      status: :unprocessable_entity
    )
  end

  def component_items
    Items.where(service_id: params[:service_id], component_id: params[:component_id])
  end

  def existing_component_items
    existing_component_uuids.map { |uuid|
      Items.where(service:, component_id: uuid).latest_version
    }.flatten
  end

  def existing_component_uuids
    service.latest_metadata.autocomplete_component_uuids
  end
end
