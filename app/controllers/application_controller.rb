
class ApplicationController < ActionController::API
  include Errors::ErrorsHandler
  include Errors::Helpers
  include Pundit::Authorization
  after_action :refresh_token, only: :authorize_request, if: :token_expired?

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
    begin
      raise if bearer.blank?
      @current_user = Users::Authorization.call(request.headers)
    rescue JWT::ExpiredSignature => e
      refresh_token
    rescue RuntimeError => e
      raise Errors::ErrorsHandler::JwtDecodeError, "No token provided."
    rescue JWT::DecodeError => e
      raise Errors::ErrorsHandler::JwtDecodeError, e
    end
  end

  def token_expired?
    authorize_request["message"] == "Signature has expired"
  end

  def pundit_user
    authorize_request
  end

  def location_setup
    location_object = request.location
    location = Location.create!(
      city: location_object.first[:city],
      city: location_object.first[:country]
    )
    { location: location.id, location_type: location.locatable_type }
  end
end
