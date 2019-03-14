class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :category
      t.string :name
      t.text :short_description
      t.text :install
      t.boolean :is_sla, null: false, defailt: false
      t.string :sla
      t.integer :popularity, index: true, default: 0
      t.boolean :has_free_request, null: false, default: false
      t.timestamps
    end
  end
end
