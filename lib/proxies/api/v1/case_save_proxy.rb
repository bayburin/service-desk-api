module Api
  module V1
    class CaseSaveProxy
      attr_reader :kase

      def initialize(kase)
        @kase = kase
      end

      def method_missing(method_name, *args)
        if need_to_respond?(method_name)
          process_params
          kase.send(method_name, *args)
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args)
        need_to_respond?(method_name) || super
      end

      private

      def need_to_respond?(method_name)
        %w[save update].include?(method_name.to_s)
      end

      def process_params
        processing_item unless kase.without_item

        ::Rails.logger.info "Case after processing: #{kase.inspect}"
      end

      def processing_item
        kase.item_id = kase.item.item_id
        kase.invent_num = kase.item.invent_num
      end
    end
  end
end
