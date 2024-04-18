module Errors
  module Helpers
    def skip_action
      render json: {  message: 'No results' }, status: 405
    end

    def no_training_data
      { message: 'No data updated', status: 303 }
    end
  end
end
