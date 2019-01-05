module Doorkeeper
  FactoryBot.define do
    factory :doorkeeper_token, class: AccessToken do
      resource_owner_id { 12_880 }
      token { 'fake_jwt_token' }
      refresh_token { 'fake_refresh_token' }
      expires_in { 7200 }
    end
  end
end
