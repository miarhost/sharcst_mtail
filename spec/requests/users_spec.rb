require 'rails_helper'
require 'bunny'
describe 'Users', type: :request do

  let!(:user) { create(:user) }
  let!(:team) { create(:team) }

  describe 'Token authorization' do
    context 'unauthorized' do
     include_examples 'v1:unauthorized_request', :patch, '/api/v1/users/update_membership', params: { team_id: 1 }
     include_examples 'v1:unauthorized_request', :post, '/api/v1/users/enqueue_parser_topic',  params: { starts: '2023-09-07', ends: '2024-03-07'}
    end
  end

  describe 'PATCH /api/v1/users/update_membership' do
  include_context 'v1:authorized_request'
    it 'should attach user to a team' do
      patch '/api/v1/users/update_membership', params: { team_id: team.id },
        headers: { Authorization: "Bearer #{authenticate}" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include_json(
        {
          "last_name": user.last_name,
          "email": user.email,
          "team_id": team.id
        }
      )
      expect(user.reload.team_id).to eq(team.id)
    end
  end

  describe 'POST /api/v1/users/enqueue_parser_topic' do
    let!(:publisher) { Parsers::RecommendedExternalQueue.new(user.id, Date.today, Date.today - 3.months).execute }
    let!(:message) { RedisData::UserTopicsForParser.call(user.id, Date.today, Date.today - 3.months)}

    include_context "v1:authorized_request"
    context 'successful request contains logger success message' do
      it 'returns enqueued logger message for current user id' do
        post '/api/v1/users/enqueue_parser_topic', params: { starts: '2023-09-07', ends: '2024-03-07'},
        headers: { Authorization: "Bearer #{authenticate}" }
        expect(response).to have_http_status(:created)
        expect(response.body).to include_json(
          {
              "result": message,
              "message": publisher[:message]
          }
        )

      end
    end

    context 'queue processed with errors' do
      it 'returns logger error message' do
        post '/api/v1/users/enqueue_parser_topic', params: {},
        headers: { Authorization: "Bearer #{authenticate}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json(
          {
            "status": "unprocessable_entity",
            "message": "Please fill the fields above"
          }
        )
      end
    end
  end
end
