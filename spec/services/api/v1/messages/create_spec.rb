require 'rails_helper'

RSpec.describe 'Messages create service' do
  describe Api::V1::Messages::Create do
    let(:user) { create(:user) }
    let(:params) { { message: {} } }
    subject { described_class.new(user, params[:message]) }

    context 'invalid params' do
      it 'fails to create a message' do
        message = subject.call

        expect(message).not_to be_valid
        expect(message).not_to be_persisted
      end
    end

    context 'valid params' do
      let(:params) {
        {
          message:
          {
            title: 'abc',
            description: 'desc',
            user_id: user.id
          }
        }
      }

      it 'creates a message' do
        message = subject.call

        expect(message).to be_valid
        expect(message).to be_persisted
      end
    end
  end
end
