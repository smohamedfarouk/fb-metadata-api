class Metadata < ApplicationRecord
  belongs_to :service
  validates :locale, :data, :created_by, presence: true

  scope :by_locale, ->(locale) { where(locale: locale) }
  scope :latest_version, -> { ordered.first }
  scope :ordered, -> { order(created_at: :desc) }
  scope :all_versions, -> { select(:id, :created_at) }

  def autocomplete_uuids
    autocomplete_components.map { |component| component['_uuid'] }
  end

  private

  def all_components
    data['pages'].map { |page| page['components'] }.compact
  end

  def autocomplete_components
    all_components.flatten.select { |c| c['_type'] == 'autocomplete' }
  end
end
