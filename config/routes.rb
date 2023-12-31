require 'sidekiq/web'
require 'sidekiq-status/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_required'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  use_doorkeeper
  namespace :api do
    namespace :v1 do

      root 'uploads#public_downloads_list'
      post '/users/login', to: 'users#login'
      resources :uploads do
        member do
          post 'upload_file', to: 'uploads#upload_file'
          delete 'remove_file', to: 'uploads#remove_file'
          get 'load_prediction_for_infos', to: 'uploads#load_prediction_for_infos'
          get 'webhook_infos', to: 'uploads#webhook_infos'
          get 'download_file', to: 'uploads#download_file'
        end
        collection do
          get 'public_downloads_list', to: 'uploads#public_downloads_list'
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
        collection do
          post 'messenger_alert_for_admins', to: 'webhooks#messenger_alert_for_admins'
        end
      end

      resources :newsletters do
        member do
          post 'sms_users_newsletter', to: 'newsletters#sms_users_newsletter'
          post 'email_users_newsletter', to: 'newsletters#email_users_newsletter'
        end
        collection do
          post 'monthly_uploads_newsletter', to: 'newsletters#monthly_uploads_newsletter'
        end
      end

      resources :disco_recommendations, only: [] do
        collection do
          post 'queue_recommendations_for_user', to: 'disco_recommendations#queue_recommendations_for_user'
          get 'queue_daily_recommendations_for_items', to: 'disco_recommendations#queue_daily_recommendations_for_items'
        end
      end

      resources :subscriptions

      resources :teams
      patch 'users/update_membership', to: 'users#update_membership'
    end
  end
end
