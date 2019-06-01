module Api
  module V1
    module Messages
      class Create
        def initialize(params)
          @params = params
        end

        def call
          create_message
        end

        private

        def create_message
          message = Message.new(@params)

          message.save

          message
        end
      end
    end
  end
end
