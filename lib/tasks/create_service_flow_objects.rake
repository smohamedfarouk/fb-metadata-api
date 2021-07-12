desc "
Creates the service flow objects from the pages array
Usage
rake create_service_flow_objects
"
task create_service_flow_objects: :environment do |_t, _args|
  require_relative 'new_flow_page_generator'

  services = Service.all
  services.each do |service|
    latest_metadata = service.latest_metadata
    metadata = latest_metadata.data

    next if metadata['flow'].present?

    puts "Creating service flow for #{service.id} => #{service.name}\n"
    service_flow = metadata['pages'].each_with_index.inject({}) do |hash, (page, index)|
      hash.merge(
        NewFlowPageGenerator.new(
          page_uuid: page['_uuid'],
          page_index: index,
          latest_metadata: metadata
        ).to_metadata
      )
    end

    begin
      if MetadataPresenter::ValidateSchema.validate(service_flow, 'flow.base')
        metadata['flow'] = service_flow
        metadata['pages'][0] = metadata['pages'][0].except('steps')
        latest_metadata.data = metadata
        latest_metadata.save!
      end
    rescue StandardError => e
      puts "Failed to create service flow for #{service.id} => #{service.name}\n"
      puts e.message
    end
  end
end
