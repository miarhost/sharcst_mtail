require 'rails_helper'
require 'sidekiq/testing'
describe 'Categories', type: :request do

  let!(:category) { create(:category)}

  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/categories/1/update_recommendations_stats', params: {}
    end
  end

  after { Sidekiq::Testing.fake! }

  describe "POST /api/v1/categories/:id/update_recommendations_stats" do
    include_context 'v1:authorized_request'
    context 'returns processing job status' do
      it 'enqueues stat creating worker' do
        expect do
          post "/api/v1/categories/#{category.id}/update_recommendations_stats",
          headers: { Authorization: "Bearer: #{authenticate}"}

         end.to change(Update::FillRecsStatWorker.jobs, :size).by(1)

        expect(response).to have_http_status(202)
      end
    end
  end

  describe "GET /api/v1/categories/:id/show_recommendations_stats" do
    let!(:recs_stat_related) { create(:recommendations_stat, statable_id: cat_stat_related.id, statable_type: cat_stat_related.class.name ) }
    let!(:cat_stat_related) { create(:category_stat, category_id: category.id) }

    let!(:recs_stat_unrelated) { create(:recommendations_stat) }
    let!(:cat_stat_unrelated) { create(:category_stat) }
    context "shows selected category's stat objects" do
      it 'shows list of serialized items with attributes of stat records related to category' do
        get "/api/v1/categories/#{category.id}/show_recommendations_stats"
        expect(response.body).to include_json(
          [
            {
              "recs_stat": {
                  "uploads_recs": recs_stat_related.uploads_recs,
                  "infos_ratings": recs_stat_related.infos_ratings,
                  "user_ids": recs_stat_related.user_ids
              },
              "related_topics": cat_stat_related.related_topics
            }
          ]
        )
      end

      it "doesn't show not related stat objects" do
        get "/api/v1/categories/#{category.id}/show_recommendations_stats"
        expect(response.body).to include_json(
          [
            {
              "recs_stat": {
                  "uploads_recs": recs_stat_unrelated.uploads_recs,
                  "infos_ratings": recs_stat_unrelated.infos_ratings,
                  "user_ids": recs_stat_unrelated.user_ids
              },
              "related_topics": cat_stat_unrelated.related_topics
            }
          ]
        )
      end
    end
  end
end
