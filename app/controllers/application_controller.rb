class ApplicationController < ActionController::API
  include Errors::ErrorsHandler
  include ActionController::MimeResponds

  def doorkeeper_unauthorized_render_options(error = nil)
    { json: { error => 'Not Authorized by OAuth' } }
  end

  def paginate_collection(collection, page, num)
    Kaminari.paginate_array(collection).page(page).per(num)
  end

  def authorize_request
    Users::Authorization.call(request.headers) if request.headers['HTTP_AUTHORIZATION']
  end
end
