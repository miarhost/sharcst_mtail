  shared_examples 'v1:unauthorized_request' do |method, url, params|
    let(:user) { FactoryBot.create(:user) }
    let(:authenticate) { Users::Authentication.call(user.email, '111111') }
    it "doesn't proceed a request without token" do
      send(method, url, params)
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
    it 'calls authorization check and return user if user is valid' do
      allow(Users::Authorization).to receive(:call).and_return(user)
    end
  end
