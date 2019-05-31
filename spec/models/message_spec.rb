require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    user = FactoryBot.create(:user)
    subject { FactoryBot.create(:message, user: user) }

    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:user) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
