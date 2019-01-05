FactoryBot.define do
  factory :auth_center_token do
    resource_owner_id { 12_880 }
    token_type { 'Bearer' }
    expires_in { 31_536_000 }
    access_token { 'fake_jwt_token_from_auth_center' }
    refresh_token { 'fake_refresh_token_from_auth_center' }
  end
end
