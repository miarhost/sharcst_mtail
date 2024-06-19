module Errors
  module Helpers
    def skip_action
      render json: {  status: 405, message: 'No results' }, status: 405
    end

    def no_training_data
      { message: 'No data updated', status: 303 }
    end

    def no_training_data_response
      render json: { status: 303, message: 'No Training Data'}, status: 303
    end

    def dataset_structure_errors
      render json: { message: 'Missing data entry in training set', status: 405  }, status: 405
    end
    # which results to " 500 #<KeyError: key not found: :score>", or "Missing UserId"
  end
end
