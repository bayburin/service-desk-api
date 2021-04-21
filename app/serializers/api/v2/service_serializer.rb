module Api
  module V2
    class ServiceSerializer < ActiveModel::Serializer
      attributes :id, :category_id, :name, :short_description, :install, :is_hidden, :has_common_case, :popularity
    end
  end
end
