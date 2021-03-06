module Api
  module V1
    module Questions
      class DraftState < AbstractState
        def update(attributes)
          form = QuestionForm.new(question)
          return true if form.validate(attributes) && form.save

          question.errors.merge!(form.errors)
          false
        end

        def publish
          publish = Publish.new(question)
          return true if publish.call

          question.errors.merge!(publish.errors)
          false
        end

        def destroy
          question.destroy
        end
      end
    end
  end
end
