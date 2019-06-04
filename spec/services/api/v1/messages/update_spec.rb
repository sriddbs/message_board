require 'rails_helper'

RSpec.describe 'Messages update service' do
  describe Api::V1::Messages::Update do
    let(:user) { create(:user) }
    let(:message) { create(:message, user: user) }
    let(:params) {
      {
        message: {
          user_id: user.id,
          title: '',
          description: ''
        }
      }
    }
    subject { described_class.new(message, params[:message]) }

    context 'invalid params' do
      it 'fails to update the message' do
        message = subject.call

        expect(message).not_to be_valid
        expect(message.errors).not_to be_empty
      end
    end

    context 'valid params' do
      let(:params) {
        {
          message:
          {
            description: 'desc1',
            user_id: user.id
          }
        }
      }

      it 'updates the message' do
        message = subject.call

        expect(message).to be_valid
        expect(message.errors).to be_empty
        expect(message.description).to eql('desc1')
      end
    end
  end
end
