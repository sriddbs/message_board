module Api
  module V1
    class MessagesController < BaseController
      def index
        messages = Message.order('created_at DESC')

        json_response(messages, paginate: true)
      end

      def create
        message = Messages::Create.new(message_params).call

        json_response message
      end

      def update
        user = User.find(params[:message][:user_id])
        message = user.messages.find(params[:id])

        Messages::Update.new(message, message_params).call

        json_response(message)
      end

      private

      def message_params
        params.require(:message).permit(:title, :description, :user_id)
      end
    end
  end
end
