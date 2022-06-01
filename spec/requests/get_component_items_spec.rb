RSpec.describe 'GET /services/:service_id/items/all' do
  let(:response_body) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when service exists' do
    let!(:service) do
      create(
        :service,
        name: 'Service 1',
        metadata: [metadata]
      )
    end
    let(:metadata) do
      build(:metadata, data: {
        configuration: {
          _id: 'service',
          _type: 'config.service'
        },
        pages: []
      })
    end
    let(:component_id_one) { '7a33f18e-c0dd-4a3b-bfb6-da48db2f8e3a' }
    let(:component_id_two) { '37fe84cd-117f-42f4-a5e9-8a13cd9c3e34' }
    let!(:items_one) do
      create(
        :items,
        service: service,
        component_id: component_id_one,
        data: [
          {
            "text": 'demogorgon',
            "value": '100'
          },
          {
            "text": 'mind flayer',
            "value": '200'
          }
        ]
      )
    end
    let!(:items_two) do
      create(
        :items,
        service: service,
        component_id: component_id_two,
        data: [
          {
            "text": 'vecna',
            "value": '300'
          }
        ]
      )
    end

    before do
      get "/services/#{service.id}/items/all", as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns all components and items for a service' do
      expect(response_body['items']).to match_array(
        [
          {
            '7a33f18e-c0dd-4a3b-bfb6-da48db2f8e3a' => [
              { 'text' => 'demogorgon', 'value' => '100' },
              { 'text' => 'mind flayer', 'value' => '200' }
            ]
          },
          {
            '37fe84cd-117f-42f4-a5e9-8a13cd9c3e34' => [
              { 'text' => 'vecna', 'value' => '300' }
            ]
          }
        ]
      )
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/items/all', as: :json
    end

    it 'returns not found response' do
      expect(response.status).to be(404)
    end

    it 'returns not found message' do
      expect(response_body).to eq({
        'message' => ["Couldn't find Service with 'id'=1234-abcdef"]
      })
    end
  end
end
