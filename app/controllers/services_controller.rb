class ServicesController < ApplicationController
  SERVICE_EXISTS = 'Name has already been taken'.freeze

  def create
    service = Service.new(service_params)

    if service.save
      metadata = service.latest_metadata

      render(
        json: MetadataSerialiser.new(service, metadata).attributes,
        status: :created
      )
    else
      if service.errors.full_messages.include?(SERVICE_EXISTS)
        Rails.logger.info("Service with #{service.name} already exists")
      end

      render json:
        ErrorsSerializer.new(
          message: service.errors.full_messages
        ).attributes, status: :unprocessable_entity
    end
  end

  def services_for_user
    services = Service.where(created_by: params[:user_id])

    render json: ServicesSerializer.new(services).attributes, status: :ok
  end
end
