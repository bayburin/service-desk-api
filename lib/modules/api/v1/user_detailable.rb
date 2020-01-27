module Api
  module V1
    module UserDetailable
      attr_reader :details

      def details=(params)
        @details = UserDetails.new(params)
      end

      def load_details
        data = Employees::Employee.new(:exact).load_users(tns: [tn])
        self.details = data ? data['data'][0] : {}
        self
      end
    end
  end
end
