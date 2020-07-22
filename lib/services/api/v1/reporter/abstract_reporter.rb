module Api
  module V1
    module Reporter
      class AbstractReporter
        def send
          raise 'Does not implement error'
        end
      end
    end
  end
end
