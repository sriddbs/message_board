require 'rails_helper'

RSpec.describe 'Messages Request spec', type: :request do
  describe 'Messages API' do
    describe 'GET /api/v1/messages' do
      it 'returns all the messags' do
        user = create(:user)
        messages = create_list(:message, 3, user: user)

        get '/api/v1/messages'

        expect(response).to be_successful
        expect(response.parsed_body.size).to eql(3)
      end
    end

    describe 'POST /api/v1/messages' do
      let(:user) { FactoryBot.create(:user) }
      let(:params) { { message: { title: 'abc', description: 'desc', user_id: user.id } } }

      context 'when params are valid' do
        it 'creates a message for a given user' do
          expect { post '/api/v1/messages', params: params }.to change { Message.count }.by(1)

          message = Message.last

          expect(response).to be_successful
          expect(response.parsed_body).to eql({
            "id" => message.id,
            "title" => message.title,
            "slug" => message.slug,
            "description" => message.description,
            "user" => {
              "id" => message.user_id,
              "email" => message.user.email
            }
          })
        end
      end

      context 'when params are invalid' do
        params = { message: { title: 'abc' } }

        it 'throws error message' do
          expect { post '/api/v1/messages', params: params }.to_not change { Message.count }

          expect(response.status).to eql(422)
          expect(response.parsed_body).to eql({"errors"=>{"description"=>["can't be blank"], "user"=>["can't be blank", "must exist"]}})
        end
      end
    end
  end
end
