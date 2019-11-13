module Api
  module V1
    class ResponsibleUserDetailsSerializer < ActiveModel::Serializer
      attributes :id_tn, :last_name, :first_name, :middle_name, :full_name, :tn, :dept, :phone
    end
  end
end
