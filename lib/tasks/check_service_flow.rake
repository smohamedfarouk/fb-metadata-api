desc "
Check if the service pages array and service flow are in the same order
Usage
rake check_service_flow
"
task check_service_flow: :environment do |_t, _args|
  Service.all.each do |service|
    printf '.'
    metadata = service.latest_metadata.data
    page_uuids = metadata['pages'].map { |page| page['_uuid'] }
    grid = MetadataPresenter::Grid.new(MetadataPresenter::Service.new(metadata))
    flow_uuids = grid.ordered_pages.map(&:uuid)

    next unless page_uuids != flow_uuids

    puts "\n******************"
    puts service.id
    puts 'Service flow does not match'
    puts "******************\n"
  end
end
