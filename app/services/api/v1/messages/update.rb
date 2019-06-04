module Api
  module V1
    module Messages
      class Update
        def initialize(message, params)
          @params = params
          @message = message
        end

        def call
          update_message
        end

        private

        def update_message
          @message.update(@params)
          @message
        end
      end
    end
  end
end
