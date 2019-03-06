class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :short_description
      t.integer :popularity, index: true, default: 0
      t.timestamps
    end
  end
end
