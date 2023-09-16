
class ApplicationController < ActionController::API
  include Errors::ErrorsHandler

  def doorkeeper_unauthorized_render_options(error = nil)
    { json: { error => 'Not Authorized by OAuth' } }
  end

  def paginate_collection(collection, page, num)
    Kaminari.paginate_array(collection).page(page).per(num)
  end

  def bearer
    request.headers['HTTP_AUTHORIZATION']
  end

  def authorize_request
    raise if bearer.blank?
    @current_user = Users::Authorization.call(request.headers)
  rescue RuntimeError => e
    raise Errors::ErrorsHandler::JwtDecodeError, "No token provided."
  rescue JWT::DecodeError => e
    raise Errors::ErrorsHandler::JwtDecodeError, e
  end
end
