class CreateUserRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_recommendations do |t|
      t.string :title
      t.string :link
      t.integer :order

      t.timestamps
    end
  end
end
