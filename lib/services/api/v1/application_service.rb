module Api
  module V1
    class ApplicationService
      include ActiveModel::Validations

      attr_reader :data, :result, :params

      def initialize(*_args); end
    end
  end
end
