module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session

      respond_to :json

      def json_response(response)
        if response.try(:errors).present?
          errors_hash = response.errors.messages

          render json: { errors: errors_hash }, status: 422
        elsif response.try(:destroyed?)
          render json: {}
        else
          render json: response
        end
      end
    end
  end
end
