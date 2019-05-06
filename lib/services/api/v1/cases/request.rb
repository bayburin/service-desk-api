module Api
  module V1
    module Cases
      class Request < Api::V1::Request
        API_ENDPOINT = ENV['ASTRAEA_NAME']
      end
    end
  end
end
