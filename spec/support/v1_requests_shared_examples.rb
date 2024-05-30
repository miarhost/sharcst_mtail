  shared_examples 'v1:unauthorized_request' do |method, url, params|
    let(:user) { FactoryBot.create(:user) }
    let(:authenticate) { Users::Authentication.call(user.email, '111111', '193.16.54.78') }
    it "doesn't proceed a request without token" do
      send(method, url, params: params || {})
      request.headers["Authorization"] = "Bearer #{authenticate}"
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include_json(
        {
          "status": "unauthorized",
          "message": "No token provided."
        }
      )
    end
  end

  shared_context 'v1:authorized_request' do
    let(:user) { FactoryBot.create(:user) }
    let!(:authenticate) { Users::Authentication.call(user.email, user.password, '193.16.54.78')[:jwt_token] }
    it 'calls authorization check and return user if user is valid' do
      expect(authenticate).to start_with('ey')
    end
  end
