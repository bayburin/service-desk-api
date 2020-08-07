require 'rails_helper'

module Api
  module V1
    module AppTemplates
      RSpec.describe AppTemplateForm, type: :model do
        subject { described_class.new(AppTemplate.new) }
        let(:params) { { ticket: { name: 'test' } } }

        it_behaves_like 'TicketableForm' do
          let(:ticketable_object) { create(:app_template) }
        end
      end
    end
  end
end
