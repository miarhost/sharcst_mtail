Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :uploads do
        member do
          post 'upload_file', to: 'uploads#upload_file'
          delete 'remove_file', to: 'uploads#remove_file'
          get 'load_prediction_for_infos', to: 'uploads#load_prediction_for_infos'
          get 'webhook_infos', to: 'uploads#webhook_infos'
        end
      end

      resources :uploads_infos do
        member do
          post 'generate_report', to: 'uploads_infos#generate_report'
          delete 'remove_report', to: 'uploads_infos#remove_report'
          patch 'update_streaming_infos', to: 'uploads_infos#update_streaming_infos'
        end
      end
    end
  end
end
