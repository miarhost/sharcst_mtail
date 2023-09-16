module Errors
  module ErrorsHandler
    class JwtDecodeError < StandardError; end
    class JwtVerificationError < StandardError; end
    class JwtExpiredSignatureError < StandardError; end
    class Errors::ErrorsHandler::JwtInvalidPayload; end
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
      render json: { status: :uforbidden, message: error.message }, status: 403
    end
  end
end
