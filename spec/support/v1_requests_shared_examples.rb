  shared_examples 'v1:authorize_request' do |request|
    def authenticate
      before(:each) do
        user = FactoryBot.create(:user)
        Users::Authentication.call(user.email, user.password)
      end
    end

    def send_request_with_token
      request.headers["Authorization"] = "Bearer #{authenticate}"
    end

    def return_user
      Users::Authorization.call(send_request_with_token)
    end
  end

  shared_context 'v1:authorized_request' do
    include_examples 'v1:authorize_request'
  end

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
