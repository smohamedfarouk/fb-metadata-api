RSpec.describe 'POST /services/:id/components/:id/items/all', type: :request do
  let(:response_body) { JSON.parse(response.body) }
  let(:service) { create(:service) }
  let(:component_id) { 'e0fdd04a-b876-4ad5-8bda-2d2f613d7da8' }
  let(:keys) { %i[service_id items] }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
    post "/services/#{service.id}/components/#{component_id}/items/all", params: params, as: :json
  end

  let(:items) do
    {
      service_id: service.id,
      created_by: service.created_by,
      component_id: component_id,
      data: [{
        "text": 'foo',
        "value": 'bar'
      }]
    }
  end

  context 'when valid attributes' do
    let(:params) { items }

    it 'returns created status' do
      expect(response.status).to be(201)
    end

    it 'creates the record' do
      expect(
        Items.exists?(service_id: service.id)
      ).to be_truthy
    end
  end

  context 'when invalid attributes' do
    let(:params) { {} }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end
  end

  context 'when an attribute is missing' do
    let(:params) { items.except(:data) }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end
  end
end
