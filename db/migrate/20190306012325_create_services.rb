class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :category
      t.string :name
      t.string :short_description
      t.text :install
      t.boolean :is_sla, null: false, defailt: false
      t.string :sla
      t.integer :popularity, index: true, default: 0
      t.timestamps
    end
  end
end
