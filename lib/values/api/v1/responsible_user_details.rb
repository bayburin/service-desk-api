module Api
  module V1
    class ResponsibleUserDetails
      # include ActiveModel::Model
      include ActiveModel::Serialization

      attr_reader :id_tn, :last_name, :first_name, :middle_name, :full_name, :tn, :dept, :phone

      def initialize(attributes)
        @id_tn = attributes['id']
        @last_name = attributes['lastName']
        @first_name = attributes['firstName']
        @middle_name = attributes['middleName']
        @full_name = attributes['fullName']
        @tn = attributes['personnelNo']
        @dept = attributes['deptForDocs']
        @phone = attributes['phoneText']
      end
    end
  end
end
