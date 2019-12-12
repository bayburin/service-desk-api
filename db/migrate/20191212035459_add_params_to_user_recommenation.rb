class AddParamsToUserRecommenation < ActiveRecord::Migration[5.2]
  def change
    add_column :user_recommendations, :external, :boolean, after: :title, default: false
    add_column :user_recommendations, :query_params, :json, after: :link
  end
end
