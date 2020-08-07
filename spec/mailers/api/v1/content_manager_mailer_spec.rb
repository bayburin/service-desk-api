require "rails_helper"

module Api
  module V1
    RSpec.describe ContentManagerMailer, type: :mailer do
      let(:receiver) { create(:content_manager_user) }

      shared_examples_for 'a mailer' do
        let(:sender) { 'uivt06@iss-reshetnev.ru' }

        it 'render the receiver email' do
          expect(mail.to).to eq([receiver.details.email])
        end

        it 'render the sender email' do
          expect(mail.from).to eq([sender])
        end
      end

      describe '#question_created_email' do
        let(:operator) { create(:operator_user) }
        let(:question) { create(:question, correction: create(:question)) }
        let(:mail) { described_class.question_created_email(receiver, question.ticket, current_user: operator, origin: '') }

        it 'render the subject' do
          expect(mail.subject).to eq("Портал \"Техподдержка УИВТ\": добавлен новый вопрос №#{question.ticket.id}")
        end

        it_behaves_like 'a mailer'
      end

      describe '#question_updated_email' do
        let(:operator) { create(:operator_user) }
        let(:question) { create(:question, correction: create(:question)) }
        let(:mail) { described_class.question_updated_email(receiver, question.ticket, current_user: operator, origin: '') }

        it 'render the subject' do
          expect(mail.subject).to eq("Портал \"Техподдержка УИВТ\": вопрос №#{question.ticket.id} изменен")
        end

        it_behaves_like 'a mailer'
      end

      describe '#search_daily_statistics_email' do
        let(:date) { Date.today }
        let(:search_results) { create_list(:search_result_event, 3) }
        let(:mail) { described_class.search_daily_statistics_email(receiver, search_results.pluck(:properties), date: date.to_s) }

        it 'render the subject' do
          expect(mail.subject).to eq("Портал \"Техподдержка УИВТ\": поисковые запросы пользователей за #{date.strftime('%d.%m.%Y')}")
        end

        it_behaves_like 'a mailer'
      end
    end
  end
end
