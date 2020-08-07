require 'rails_helper'

module Api
  module V1
    RSpec.describe SvtApi, type: :model do
      subject { SvtApi }

      describe '::items' do
        let(:user) { build(:user) }
        let(:params) { { foo: :bar } }
        let(:svt_url) { "#{ENV['SVT_URL']}/user_isses/#{user.id_tn}/items" }

        before { stub_request(:get, /#{svt_url}.*/).to_return(status: 200, body: '', headers: {}) }

        it 'sends :get request for current user with params' do
          subject.items(user, params)

          expect(WebMock).to have_requested(:get, svt_url).with(query: params)
        end

        it 'returns instance of Faraday::Response class' do
          expect(subject.items(user, params)).to be_instance_of(Faraday::Response)
        end
      end
    end
  end
end
