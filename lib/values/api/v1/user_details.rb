module Api
  module V1
    class UserDetails
      include ActiveModel::Serialization

      attr_reader :id_tn, :last_name, :first_name, :middle_name, :full_name, :tn, :dept, :phone, :email

      def initialize(attributes)
        return unless attributes

        @id_tn = attributes['id']
        @last_name = attributes['lastName']
        @first_name = attributes['firstName']
        @middle_name = attributes['middleName']
        @full_name = attributes['fullName']
        @tn = attributes['personnelNo']
        @dept = attributes['deptForDocs']
        @phone = attributes['phoneText']
        @email = attributes['emailText']
      end
    end
  end
end
