module Api
  module V1
    module Messages
      class Destroy
        def initialize(message)
          @message = message
        end

        def call
          destroy_message
        end

        private

        def destroy_message
          @message.destroy
        end
      end
    end
  end
end
