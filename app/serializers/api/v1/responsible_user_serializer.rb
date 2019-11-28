module Api
  module V1
    class ResponsibleUserSerializer < ActiveModel::Serializer
      attributes :id, :responseable_type, :responseable_id, :tn, :details

      def details
        object.details ? ActiveModel::SerializableResource.new(object.details) : nil
      end
    end
  end
end
