RSpec.describe Metadata, type: :model do
  subject(:metadata) do
    Metadata.new(
      service: service,
      locale: 'en',
      data: data,
      created_by: 'Maverick'
    )
  end
  let(:data) do
    {
      configuration: {},
      pages: [
        { "_id": 'page.start' },
        {
          "_id": 'page.countries',
          "components": [
            {
              "_type": 'autocomplete',
              "_uuid": component_id_one
            }
          ]
        },
        {
          "_id": 'page.names',
          "components": [
            {
              "_type": 'text',
              "_uuid": SecureRandom.uuid
            }
          ]
        },
        {
          "_id": 'page.cakes',
          "components": [
            {
              "_type": 'autocomplete',
              "_uuid": component_id_two
            }
          ]
        },
        { "_id": 'page.checkanswers' }
      ]
    }
  end
  let(:component_id_one) { SecureRandom.uuid }
  let(:component_id_two) { SecureRandom.uuid }

  describe '#autocomplete_uuids' do
    let(:service) { create(:service) }

    context 'when there are autocomplete components' do
      let(:expected_uuids) { [component_id_one, component_id_two] }

      before do
        create(:metadata, service: service, data: data)
        create(
          :items,
          service: service,
          component_id: component_id_one,
          service_id: service.id
        )
        create(
          :items,
          service: service,
          component_id: component_id_two,
          service_id: service.id
        )
      end

      it 'returns uuids of autocomplete items in a service' do
        expect(metadata.autocomplete_uuids).to eq(expected_uuids)
      end
    end

    context 'when there are no autocomplete components' do
      let(:metadata) { create(:metadata, service: service) }

      it 'returns empty' do
        expect(metadata.autocomplete_uuids).to be_empty
      end
    end
  end
end
