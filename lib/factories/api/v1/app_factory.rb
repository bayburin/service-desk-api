module Api
  module V1
    class AppFactory
      def self.create(params = {})
        App.new(params)
      end
    end
  end
end
