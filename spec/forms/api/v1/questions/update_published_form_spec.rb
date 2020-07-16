require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe UpdatePublishedForm, type: :model do
        let(:question) do
          q = create(:question, state: :published)
          q.ticket.responsible_users << responsible_users
          q
        end
        let(:responsible_users) { create_list(:responsible_user, 2) }
        let(:params) do
          q = question.as_json(include: [
                                 answers: { include: :attachments },
                                 ticket: { include: %i[tags responsible_users] }
                               ])
          q['ticket']['name'] = 'new name'
          q['ticket'].delete('identity')
          q
        end
        subject { described_class.new(question) }

        it 'inherits from QuestionForm class' do
          expect(described_class).to be < QuestionForm
        end

        describe '#initializer' do
          it 'save received question in @original_model variable' do
            expect(subject.original_model).to eq question
          end

          it 'create form instance with new Question instance' do
            expect(subject.model).to be_a_kind_of(Question)
            expect(subject.model.new_record?).to be_truthy
          end
        end

        describe '#validate' do
          before { subject.validate(params) }

          it 'set original_id' do
            expect(subject.original_id).to eq question.id
          end

          it 'copy identity' do
            expect(subject.ticket.identity).to eq question.ticket.identity
          end

          it 'call #populate_attachments method for each answer' do
            subject.answers.each do |answer|
              expect(answer).to receive(:populate_attachments)
            end

            subject.validate(params)
          end

          it 'set nil to each id attribute' do
            expect(subject.id).to be_nil
            expect(subject.answers.all? { |a| a.id.nil? }).to be_truthy
            expect(subject.ticket.id).to be_nil
            expect(subject.ticket.responsible_users.all? { |u| u.responseable_id.nil? && u.id.nil? }).to be_truthy
          end
        end
      end
    end
  end
end
