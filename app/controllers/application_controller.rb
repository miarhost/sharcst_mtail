class ApplicationController < ActionController::API
  include Errors::ErrorsHandler

  def doorkeeper_unauthorized_render_options(error = nil)
    { json: { error => 'Not Authorized by OAuth' } }
  end

  def paginate_collection(collection, page, num)
    Kaminari.paginate_array(collection).page(page).per(num)
  end

  def authorize_request
    @current_user = Users::Authorization.call(request.headers) if request.headers['HTTP_AUTHORIZATION']
  rescue ActiveRecord::RecordNotFound => e
    not_authorized_message
  end
end
