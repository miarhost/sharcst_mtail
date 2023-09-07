class ApplicationController < ActionController::API
  include Errors::ErrorsHandler
  include ActionController::MimeResponds

  def doorkeeper_unauthorized_render_options(error = nil)
    { json: { error => 'Not Authorized by OAuth' } }
  end

  def paginate_collection(collection, page, num)
    Kaminari.paginate_array(collection).page(page).per(num)
  end

  def current_user
    @current_user ||= User.find(Users::Authentication.current_user_id)
  end

  def authorize_request!
    token = Jwt::JwtAuth.new(current_user).generate_token
    request.headers['HTTP_AUTHORIZATION'] = "JWT #{token}"
  end
end
