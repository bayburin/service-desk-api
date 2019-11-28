module Api
  module V1
    class UserOwnsSerializer < ActiveModel::Serializer
      has_many :items
      has_many :services, serializer: Services::ServiceGuestSerializer
    end
  end
end
