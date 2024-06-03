module Errors
  module Helpers
    def skip_action
      render json: {  message: 'No results' }, status: 405
    end

    def no_training_data
      { message: 'No data updated', status: 303 }
    end

    def dataset_structure_errors
      render json: { message: 'Missing data entry in training set' }, status: 405
    end
    # which results to " 500 #<KeyError: key not found: :score>", or "Missing UserId"
  end
end
