class CreateTemplateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :template_works do |t|
      t.references :app_template, foreign_key: true, null: false
      t.string :name
      t.timestamps
    end
  end
end
