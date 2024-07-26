require 'sidekiq/web'
require 'sidekiq-status/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_required'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  use_doorkeeper
  resources :api_docs, only: [:index]
  namespace :api do
    namespace :v1 do
      root 'uploads#public_downloads_list'

      resources :users, only: [] do
        collection do
          post 'login', to: 'users#login'
          post 'refresh_token', to: 'users#refresh_token'
          patch 'update_membership', to: 'users#update_membership'
          post 'enqueue_topic', to: 'users#enqueue_topic'
          post 'enqueue_related_topics', to: 'users#enqueue_related_topics'
          get 'show_parsed_topics', to: 'users#show_parsed_topics'
        end
        member do
          get 'subscriptions_info', to: 'users#subscriptions_info'
        end
      end

      resources :uploads do
        member do
          post 'upload_file', to: 'uploads#upload_file'
          delete 'remove_file', to: 'uploads#remove_file'
          get 'load_prediction_for_infos', to: 'uploads#load_prediction_for_infos'
          get 'webhook_infos', to: 'uploads#webhook_infos'
          get 'download_file', to: 'uploads#download_file'
          patch 'update_recs', to: 'uploads#update_recs'
          post 'update_recs_by_infos', to: 'uploads#update_recs_by_infos'
        end
        collection do
          get 'public_downloads_list', to: 'uploads#public_downloads_list'
          post 'bulk_upload', to: 'uploads#bulk_upload'
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
          get 'download_report', to: 'uploads_infos#download_report'
        end
      end

      resources :webhooks do
        member do
          post 'slack_notification_for_report', to: 'webhooks#slack_notification_for_report'
        end
        collection do
          post 'messenger_alert_for_admins', to: 'webhooks#messenger_alert_for_admins'
          post 'parsed_queue_slack_logs', to: 'webhooks#parsed_queue_slack_logs'
          get 'ollama_list_to_parse', to: 'webhooks#ollama_list_to_parse'
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
          post 'queue_importance_values_lists', to: 'disco_recommendations#queue_importance_values_lists'
          patch 'update_subscription_recs', to: 'disco_recommendations#update_subscriptions_recs'
        end
      end

      resources :subscriptions do
        member do
          post 'store_topic_recommendations', to: 'subscriptions#store_topic_recommendations'
          put 'update_stats_preferences', to: 'subscriptions#update_stats_preferences'
        end
      end

      resources :teams do
        member do
          post 'store_recommendations_for_team',to: 'teams#store_recommendations_for_team'
          post 'queue_parsing_by_topic', to: 'teams#queue_parsing_by_topic'
          get 'show_parsed_by_topic', to: 'teams#show_parsed_by_topic'
        end
      end

      resources :categories do
        member do
          post 'update_recommendations_stats', to: 'categories#update_recommendations_stats'
        end
      end
    end
  end
end
