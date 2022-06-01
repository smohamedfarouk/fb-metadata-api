class CreateItems < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'
    create_table :items, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.jsonb :data, null: false
      t.string :created_by, null: false
      t.string :component_id, null: false
      t.references :service, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :items, :component_id
  end
end
