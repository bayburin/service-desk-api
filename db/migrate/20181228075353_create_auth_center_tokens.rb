class CreateAuthCenterTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_center_tokens do |t|
      t.integer :resource_owner_id
      t.string  :token_type
      t.integer :expires_in
      t.text    :access_token
      t.text    :refresh_token
      t.timestamps
    end
  end
end
