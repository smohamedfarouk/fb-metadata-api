desc "
Checks the services have correctly migrated to using the flow objects
Usage
rake check_service_flow_objects
"
task check_service_flow_objects: :environment do |_t, _args|
  result = %i[with without to_check].index_with { |_key| [] }
  services = Service.all
  services.each do |service|
    id_and_name = "#{service.id} => #{service.name}"
    metadata = service.latest_metadata.data
    if metadata['flow'].present?
      no_flow_object_for_page = metadata['pages'].any? do |page|
        metadata['flow'][page['_uuid']].blank?
      end

      incorrect_next_page = metadata['pages'].each_with_index.any? do |page, index|
        default_next = metadata['flow'][page['_uuid']]['next']['default']
        next_uuid = page == metadata['pages'].last ? '' : metadata['pages'][index + 1]['_uuid']
        default_next != next_uuid
      end

      if no_flow_object_for_page || incorrect_next_page
        result[:to_check].push(id_and_name)
      else
        result[:with].push(id_and_name)
      end
    else
      result[:without].push(id_and_name)
    end
  end

  puts "Services with flow objects:\n"
  puts result[:with].join("\n")

  puts "\nServices without flow objects:\n"
  puts result[:without].join("\n")

  puts "\nServices to check:\n"
  puts result[:to_check].join("\n")
end
