class Items < ApplicationRecord
  belongs_to :service
  validates :data, :created_by, :component_id, :service_id, presence: true
end
