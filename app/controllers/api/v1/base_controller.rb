module Api
  module V1
    class BaseController < ApplicationController
      include ErrorHandler
      include Rails::Pagination

      protect_from_forgery with: :null_session

      def json_response(response, paginate: false)
        if response.try(:errors).present?
          errors_hash = response.errors.messages

          render json: { errors: errors_hash }, status: 422
        elsif response.try(:destroyed?)
          render json: {}
        else
          paginate ? paginate(json: response) : render(json: response)
        end
      end
    end
  end
end
