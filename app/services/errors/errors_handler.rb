module Errors
  module ErrorsHandler
    class JwtDecodeError < StandardError; end
    class JwtVerificationError < StandardError; end
    class JwtExpiredSignatureError < StandardError; end
    class Errors::ErrorsHandler::JwtInvalidPayload; end
    class Twilio::REST::TwilioError < StandardError; end
    class Twilio::REST::RestError < Twilio::REST::TwilioError; end
    class Errors::ErrorsHandler::TwilioApiError; end
    class Errors::ErrorsHandler::TwilioRestError; end

    def self.included(klass)
      klass.class_eval do
        rescue_from ActiveRecord::RecordInvalid, with: :validation_error
        rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
        rescue_from Errors::ErrorsHandler::JwtVerificationError, with: :not_authorized_error
        rescue_from Errors::ErrorsHandler::JwtExpiredSignatureError, with: :not_authorized_error
        rescue_from Errors::ErrorsHandler::JwtDecodeError, with: :not_authorized_error
        rescue_from Errors::ErrorsHandler::JwtInvalidPayload, with: :not_authorized_error
        rescue_from JWT::ExpiredSignature, with: :not_authorized_error
        rescue_from JWT::InvalidPayload, with: :not_authorized_message
        rescue_from JWT::DecodeError, with: :not_authorized_error
        rescue_from Errors::ErrorsHandler::TwilioApiError, with: :external_api_error
        rescue_from Twilio::REST::TwilioError, with: :external_api_error
        rescue_from Errors::ErrorsHandler::TwilioRestError, with: :external_api_error
        rescue_from Twilio::REST::RestError, with: :external_api_error
        rescue_from Pundit::NotAuthorizedError, with: :policy_restriction_for_user
      end
    end

    def validation_error(error)
      render json: { status: :unprocessable_entity, message: error.record.errors.full_messages.to_sentence }, status: 422
    end

    def not_found_error
      render json: { status: :not_found, message: 'Record not found' }, status: 404
    end

    def not_authorized_error(error)
      render json: { status: :unauthorized, message: error.message }, status: 401
    end

    def not_authorized_message
      render json: { status: :unauthorized, message: 'User is not authorized' }, status: 401
    end

    def forbidden_error(error)
      render json: { status: :forbidden, message: error.message }, status: 403
    end

    def external_api_error
      render json: { status: :bad_request, message: error.message }, status: 400
    end

    def policy_restriction_for_user
      render json: { status: :forbidden, message: 'You are not authorized to perform this action'}, status: 403
    end
  end
end
