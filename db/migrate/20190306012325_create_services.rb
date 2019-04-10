class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :category
      t.string :name
      t.text :short_description
      t.text :install
      t.boolean :is_hidden, null: false, default: true
      t.boolean :has_common_case, null: false, default: false
      t.integer :popularity, index: true, default: 0
      t.timestamps
    end
  end
end
