require 'rails_helper'

module Api
  module V1
    module AppTemplates
      RSpec.describe Create do
        let(:app_template) { AppTemplate.new }
        let(:created_app_template) { create(:app_template) }
        let(:app_template_params) { {} }
        let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: created_app_template) }
        subject(:context) { described_class.call(params: app_template_params) }
        before do
          allow(AppTemplate).to receive(:new).and_return(app_template)
          allow(AppTemplateForm).to receive(:new).and_return(create_form_dbl)
        end

        describe '.call' do
          it 'create instance of AppTemplateForm' do
            expect(AppTemplateForm).to receive(:new).with(app_template)

            described_class.call(params: app_template_params)
          end

          context 'when form is saved' do
            before { described_class.call(params: app_template_params) }

            it 'finished with success' do
              expect(context).to be_a_success
            end

            it 'set created app_template to context' do
              expect(context.app_template).to eq app_template
            end
          end

          context 'when form is not saved' do
            let(:create_form_dbl) { double(:create_form, validate: false, save: false, errors: { message: 'test' }) }

            it 'finished with error' do
              expect(context).to be_a_failure
            end

            it 'set error to context' do
              expect(context.errors).to be_present
            end
          end
        end
      end
    end
  end
end
