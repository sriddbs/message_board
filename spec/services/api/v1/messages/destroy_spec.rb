require 'rails_helper'

RSpec.describe 'Messages destroy service' do
  describe Api::V1::Messages::Destroy do
    it 'destroys the message' do
      user = create(:user)
      message = create(:message, user: user)
      params = {
        message: {
          user_id: user.id
        }
      }

      message = described_class.new(message).call

      expect(message.destroyed?).to be_truthy
    end
  end
end
