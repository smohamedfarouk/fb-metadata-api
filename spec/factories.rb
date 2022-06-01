FactoryBot.define do
  factory :service do
    name { 'Cowboy Bebop' }
    created_by { 'Fay' }
  end

  factory :metadata do
    data { { configuration: {}, pages: [] } }
    created_by { 'Fay' }
    locale { 'en' }
  end

  factory :items do
    data { [] }
    created_by { 'Fay' }
    service_id { SecureRandom.uuid }
    component_id { SecureRandom.uuid }
  end
end
