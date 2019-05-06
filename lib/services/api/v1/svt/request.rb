module Api
  module V1
    module Svt
      class Request < Api::V1::Request
        API_ENDPOINT = ENV['SVT_NAME']
      end
    end
  end
end
