module Api
  module V1
    class ResponsibleUserSerializer < ActiveModel::Serializer
      attributes :id, :responseable_type, :responseable_id, :tn
    end
  end
end
