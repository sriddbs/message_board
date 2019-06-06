require 'rails_helper'

RSpec.describe 'Messages Request spec', type: :request do
  describe 'Messages API' do
    describe 'GET /api/v1/messages' do
      before do
        user = create(:user)
        create_list(:message, 3, user: user)
      end

      context 'default pagination params' do
        it 'returns all the messages paginated' do
          get '/api/v1/messages'

          expect(response).to be_successful
          expect(response.parsed_body.size).to eql(3)
        end
      end

      context 'per_page set to 1' do
        it 'returns 1 message per page' do
          get '/api/v1/messages', params: { per_page: 1 }

          expect(response).to be_successful
          expect(response.parsed_body.size).to eql(1)

          get '/api/v1/messages', params: { per_page: 1, page: 2 }

          expect(response).to be_successful
          expect(response.parsed_body.size).to eql(1)
        end
      end
    end

    describe 'POST /api/v1/messages' do
      let(:user) { create(:user) }
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
        context 'when user exists' do
          it 'returns status 422' do
            params = { message: { user_id: user.id, title: 'abc' } }
            expect { post '/api/v1/messages', params: params }.to_not change { Message.count }

            expect(response.status).to eql(422)
            expect(response.parsed_body).to eql({"errors"=>{"description"=>["can't be blank"]}})
          end
        end

        context 'when user does not exists' do
          it 'returns status 404' do
            params = { message: { user_id: 111111, title: 'abc' } }
            expect { post '/api/v1/messages', params: params }.to_not change { Message.count }

            expect(response.status).to eql(404)
            expect(response.parsed_body).to eql("errors"=>"Couldn't find User with 'id'=111111")
          end
        end
      end
    end

    describe 'PATCH /api/v1/messages/:id' do
      let(:user) { create(:user) }
      let(:message) { create(:message, user: user) }

      context 'when user not found' do
        it 'fails and returns error message' do
          params = {
            message: {
              user_id: 100,
              description: 'desc1'
            }
          }

          patch "/api/v1/messages/#{message.id}", params: params

          expect(response.status).to eql(404)
          expect(response.parsed_body).to eql({"errors"=>"Couldn't find User with 'id'=100"})
        end
      end

      context 'when user and message does not belong to each other' do
        let(:user_1) { create(:user) }

        it 'fails to update the message' do
          params = {
            message: {
              user_id: user_1.id,
              description: 'desc1'
            }
          }

          patch "/api/v1/messages/#{message.id}", params: params

          expect(response.status).to eql(404)
        end
      end

      context 'when user is present' do
        it 'updates the messages' do
          params = {
            message: {
              user_id: user.id,
              description: 'desc1'
            }
          }

          patch "/api/v1/messages/#{message.id}", params: params

          expect(response).to be_successful
          expect(response.parsed_body['description']).to eql('desc1')
        end
      end

      context 'invalid params' do
        it 'does not updates the message' do
          params = {
            message: {
              user_id: user.id,
              description: '',
              title: ''
            }
          }

          patch "/api/v1/messages/#{message.id}", params: params

          expect(response.status).to eql(422)
          expect(response.parsed_body).to eql({"errors"=>{"title"=>["can't be blank"], "description"=>["can't be blank"]}})
        end
      end

      describe 'DELETE /api/v1/messages/:id' do
        let(:user) { create(:user) }
        let(:message) { create(:message, user: user) }

        context 'when message exists' do
          it 'deletes the message' do
            params = {
              message: {
                user_id: user.id
              }
            }

            delete "/api/v1/messages/#{message.slug}", params: params

            expect(response).to be_successful
          end
        end

        context 'when messages does not exist' do
          it 'returns 404' do
            params = {
              message: {
                user_id: user.id
              }
            }

            delete "/api/v1/messages/111111", params: params

            expect(response.status).to eql(404)
          end
        end
      end
    end
  end
end
