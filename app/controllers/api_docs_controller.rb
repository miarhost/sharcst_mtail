class ApiDocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Sci Paper Cooperative'
      key :description, 'Share and get recommendations for researches'
      contact do
        key :name, 'miarhost'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, 'localhost:3000'
    key :basePath, '/api/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']

    security_definition :jwt do
      key :type, :jwtToken
      key :name, :jwt_token
      key :in, :header
    end
  end

  SWAGGERED_CLASSES = [
    Api::V1::UsersController,
    SwagDocs::RecTopicsPayloadModel,
    SwagDocs::TargetTopicsMaxRatedModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
