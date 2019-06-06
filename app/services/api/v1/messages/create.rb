module Api
  module V1
    module Messages
      class Create
        def initialize(user, params)
          @user = user
          @params = params
        end

        def call
          create_message
        end

        private

        def create_message
          message = @user.messages.new(@params)

          message.save

          message
        end
      end
    end
  end
end
