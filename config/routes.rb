Rails.application.routes.draw do
  use_doorkeeper
  namespace :api do
    namespace :v1 do
      post '/users/login', to: 'users#login'
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
          patch 'update_streaming_infos', to: 'uploads_infos#update_streaming_infos'
        end
        collection do
          delete 'remove_report', to: 'uploads_infos#remove_report'
          post 'deliver_predictions', to: 'uploads_infos#deliver_predictions'
        end
      end

      resources :webhooks do
        member do
          post 'slack_notification_for_report', to: 'webhooks#slack_notification_for_report'
        end
      end

      resources :newsletters do
        member do
          post 'sms_users_newsletter', to: 'newsletters#sms_users_newsletter'
        end
      end
    end
  end
end
