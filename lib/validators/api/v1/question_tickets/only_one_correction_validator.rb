module Api
  module V1
    module QuestionTickets
      class OnlyOneCorrectionValidator < ActiveModel::Validator
        def validate(record)
          return unless record.correction

          record.errors.add(:base, :correction_already_exists)
        end
      end
    end
  end
end
