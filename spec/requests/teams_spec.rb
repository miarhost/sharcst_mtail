require 'rails_helper'
require 'disco'

describe 'Teams', type: :request do
  let!(:category) { create(:category) }
  let!(:topic) { create(:topic) }
  let!(:team) { create(:team) }

  describe 'Token authorization' do
    context 'unauthorized' do
      include_examples 'v1:unauthorized_request', :post, '/api/v1/teams', params: { team: { tag: 'test category' } }
      include_examples 'v1:unauthorized_request', :patch, '/api/v1/teams/1', params: { team: { tag: 'change tag'} }
      include_examples 'v1:unauthorized_request', :delete, '/api/v1/teams/1', params: {}
      include_examples 'v1:unauthorized_request', :post, '/api/v1/teams/1/store_recommendations_for_team', params: {}
    end
  end

  describe 'POST /api/v1/teams' do
    include_context 'v1:authorized_request'
    context 'successfully creates a record' do
      it 'returns new record serialized' do
        post '/api/v1/teams/',
        headers: { Authorization: "Bearer #{authenticate}"},
        params: { team: { tag: 'test category', category_id: category.id, topic_id: topic.id } }

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json({
          'tag': 'test category',
          'users': [],
          'category': { title: category.title },
          'topic': { title: topic.title }
        })
      end
    end

    context 'fails to create a record due to validations' do
      it 'returns serialized error messages' do
        post '/api/v1/teams',
          headers: { Authorization: "Bearer: #{authenticate}"},
          params: { team: { tag: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '} }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json(
          {
            "status": "unprocessable_entity",
            "message": "Tag is too long (maximum is 55 characters)"
          }
        )
      end
    end
  end

  describe 'PATCH /api/v1/teams/:id/' do
    include_context 'v1:authorized_request'
    context 'successfully updates a record' do
      it 'returns updated record' do
        patch "/api/v1/teams/#{team.id}",
          params: { team: { tag: 'changed tag'} },
          headers: { Authorization: "Bearer: #{authenticate}"}

        expect(response).to have_http_status(:success)
        expect(response.body).to include_json(
          {
            "tag": "changed tag",
            "users": [],
            "category": {
                "title": category.title
            },
            "topic": {
                "title": topic.title
            }
          }
        )
      end
    end

    context 'fails to update a record due to validations' do
      it 'returns serialized error messages' do
        patch "/api/v1/teams/#{team.id}",
        params: { team: { tag: "" } },
        headers: { Authorization: "Bearer: #{authenticate}"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json(
          {
            "status": "unprocessable_entity",
            "message": "Tag is too short (minimum is 2 characters)"
          }
        )
      end
    end
  end

  describe 'DELETE /api/v1/teams/:id/' do
    include_context 'v1:authorized_request'
    it 'removes a record from database' do
      delete "/api/v1/teams/#{team.id}", headers: { Authorization: "Bearer: #{authenticate}"}

      expect(response).to have_http_status(:no_content)
      expect{ team.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /api/v1/teams/:id/store_recommendations_for_team/' do

    include_context 'v1:authorized_request'
    context 'successfully obtain team recommendations' do
      let!(:user_1) { create(:user, team_id: team.id)}
      let!(:upload) { create(:upload, user_id: user_1.id, rating: 3, topic_id: topic.id)}
      let!(:upload_1) { create(:upload, user_id: user.id, rating: 9, topic_id: topic_1.id)}
      let!(:uploads_infos) { create_list(:uploads_info, 3, user_id: user_1.id, upload_id: upload.id) }
      let!(:uploads_infos_1) { create_list(:uploads_info, 3, user_id: user.id, upload_id: upload_1.id) }
      let!(:topic) { create(:topic, category_id: category.id)}
      let!(:topic_1) { create(:topic, category_id: category.id)}
      before do
        team.update(topic_id: topic.id, category_id: category.id)
        user.update(team_id: team.id)
      end

      it 'creates disco recs record for a team' do
        expect do
          post "/api/v1/teams/#{team.id}/store_recommendations_for_team",
            headers: { Authorization: "Bearer #{authenticate}" }
        end.to change(DiscoRecommendation, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(response.body).to include_json(
        [
          {
              "id": upload.id,
              "max": upload.rating
          }
        ])
      end
    end

    context 'fail to create and save team recommendations' do
      let(:team_1) { create(:team, topic_id: nil, category_id: nil)}
      it 'responds with error message' do
        post "/api/v1/teams/#{team_1.id}/store_recommendations_for_team",
          headers: { Authorization: "Bearer #{authenticate}" }
        expect(response).to have_http_status(:see_other)
        expect(response.body).to include_json(
          {
            "status": 303,
            "message": "No Training Data"
        }
        )
      end
    end
  end

  describe 'POST /api/v1/teams/:id/queue_parsing_by_topic' do
    include_context 'v1:authorized_request'
    context 'successfully queue a message to parser' do
      it 'responds with success queue message' do
        post "/api/v1/teams/#{team.id}/queue_parsing_by_topic",
          headers: { Authorization: "Bearer #{authenticate}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include_json(
          {
            "message": {
                "topic": topic.title
            },
            "result": {
                "success": "in queue"
            }
        }
        )
      end
    end

    context 'failed to queue a message to parser' do
      let!(:team_1) { create(:team, topic_id: nil) }
      it 'responds with error message' do
        post "/api/v1/teams/#{team_1.id}/queue_parsing_by_topic",
          headers: { Authorization: "Bearer #{authenticate}" }
        expect(response).to have_http_status(:method_not_allowed)
        expect(response.body).to include_json(
          {
            "status": 405,
            "message": "No results"
          }
        )
      end
    end
  end

  describe 'GET /api/v1/teams/:id/show_parsed_by_topic' do
    include_context 'v1:authorized_request'
    context 'results as successful links list record' do
      it 'shows serialized topic_digest with list_of_5 with parsed links value' do
        expect do
        get "/api/v1/teams/#{team.id}/show_parsed_by_topic",
        headers: { Authorization: "Bearer #{authenticate}" }
        end.to change(TopicDigest, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
