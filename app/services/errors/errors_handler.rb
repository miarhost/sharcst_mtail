module Errors
  module ErrorsHandler
    def self.included(klass)
      klass.class_eval do
        rescue_from ActiveRecord::RecordInvalid, with: :validation_error
        rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
      end
    end

    def validation_error(error)
      render json: { status: :unprocessable_entity, message: error.record.errors.full_messages.to_sentence }, status: 422
    end

    def not_found_error
      render json: { status: :not_found, message: 'Record not found' }, status: 404
    end
  end
end
