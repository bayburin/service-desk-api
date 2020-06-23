module Api
  module V1
    module AuthCenter
      module AccessToken
        TOKEN_PREFIX = 'token:'.freeze

        def self.get(access_token)
          Oj.load(ReadCache.redis.get("#{TOKEN_PREFIX}#{access_token}"))
        end

        def self.set(access_token, user_info)
          ReadCache.redis.set("#{TOKEN_PREFIX}#{access_token}", user_info.to_json)
        end

        def self.del(access_token)
          ReadCache.redis.del("#{TOKEN_PREFIX}#{access_token}")
        end
      end
    end
  end
end
