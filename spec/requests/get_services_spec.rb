RSpec.describe 'GET /services' do
  let(:response_body) { JSON.parse(response.body) }
  let!(:service_one) do
    create(
      :service,
      name: 'Service 1',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')]
    )
  end
  let!(:service_two) do
    create(
      :service,
      name: 'Service 2',
      created_by: 'han',
      metadata: [build(:metadata, created_by: 'han')]
    )
  end
  let!(:service_three) do
    create(
      :service,
      name: 'Service 3',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')]
    )
  end

  context 'when signed in' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      get '/services', as: :json
    end

    it 'returns success response' do
      expect(response.status).to eq(200)
    end

    it 'returns all services' do
      expect(response_body['services']).to match_array(
        [
          {
            'service_name' => service_one.name,
            'service_id' => service_one.id
          },
          {
            'service_name' => service_two.name,
            'service_id' => service_two.id
          },
          {
            'service_name' => service_three.name,
            'service_id' => service_three.id
          }
        ]
      )
    end
  end

  context 'when paginating' do
    let(:per_page) { 1 }

    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      get "/services?page=#{page}&per_page=#{per_page}", as: :json
    end

    context 'when requesting first page' do
      let(:page) { 1 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array(
          [
            {
              'service_name' => service_one.name,
              'service_id' => service_one.id
            }
          ]
        )
      end
    end

    context 'when requesting second page' do
      let(:page) { 2 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array(
          [
            {
              'service_name' => service_two.name,
              'service_id' => service_two.id
            }
          ]
        )
      end
    end
  end
end
