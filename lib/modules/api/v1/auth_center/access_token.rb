module Api
  module V1
    module AuthCenter
      # Содержит методы для работы с access_token пользователя
      module AccessToken
        TOKEN_PREFIX = 'token:'.freeze
        EXPIRED_TIME = ENV['ACCESS_TOKEN_EXPIRE_TIME']

        # Обновляет время жизни и возвращает токен
        def self.get(access_token)
          ReadCache.redis.expire(key(access_token), EXPIRED_TIME)
          Oj.load(ReadCache.redis.get(key(access_token)))
        end

        # Сохраняет токен
        def self.set(access_token, user_info)
          ReadCache.redis.set(key(access_token), user_info.to_json, ex: EXPIRED_TIME)
        end

        # Удаляет токен
        def self.del(access_token)
          ReadCache.redis.del(key(access_token))
        end

        # Возвращает имя ключа на основании полученного токена
        def self.key(access_token)
          TOKEN_PREFIX + access_token
        end
      end
    end
  end
end
