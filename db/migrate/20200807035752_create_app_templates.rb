class CreateAppTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :app_templates do |t|
      t.string :description
      t.string :destination
      t.string :message
      t.string :info
      t.timestamps
    end
  end
end
