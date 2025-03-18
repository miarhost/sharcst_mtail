
class ApplicationController < ActionController::API
  include Errors::ErrorsHandler
  include Pundit::Authorization
  after_action :refresh_token, only: :authorize_request, if: :token_expired?

  def doorkeeper_unauthorized_render_options(error = nil)
    { json: { error => 'Not Authorized by OAuth' } }
  end

  def paginate_collection(collection, page, num)
    Kaminari.paginate_array(collection).page(page).per(num)
  end

  def refresh_doorkeeper_token
    access_token = ::Doorkeeper::AccessToken.find_by(resource_owner_id: authorize_request['id'])
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
    JSON.parse(authorize_request)['message'] == "Signature has expired"
  end

  def location_setup(record)
    return if Rails.env != 'production'
    location_object = request.location
    location = Location.create!(
      city: location_object.first[:city],
      country: location_object.first[:country],
      locatable_type: record.class.name,
      locatable_id: record.id
    )

    Rails.logger.info({ location: location.id, location_type: location.locatable_type })
  end

  private

  def pundit_user
    authorize_request
  end

  def bearer
    request.headers['HTTP_AUTHORIZATION']
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def doorkeeper_token
    Doorkeeper::AuthRequests.new(bearer.split(' ').last).token_request
  end
end
