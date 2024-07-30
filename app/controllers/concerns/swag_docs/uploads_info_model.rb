module SwagDocs
  class UploadsInfoModel
    include Swagger::Blocks

    swagger_schema :UploadsInfoModel do
      key :required, %i[ user_id upload_id log_tag name streaming_infos media_type rating provider duration description static_info_block ]
      property :user_id do
        key :type, :integer
        key :format, :int64
      end
      property :upload_id do
        key :type, :integer
        key :format, :int64
      end
      property :log_tag do
        key :type, :string
      end
      property :name do
        key :type, :string
      end
      property :streaming_infos do
        key :type, :object
      end
      property :media_type do
        key :type, :integer
        key :format, :int32
      end
      property :rating do
        key :type, :integer
        key :format, :int32
      end
      property :provider do
        key :type, :string
      end
      property :duration do
        key :type, :number
        key :format, :float
      end
      property :description do
        key :type, :string
      end
      property :static_info_block do
        key :type, :object
        property :streaming_statistics do
          key :type, :object
          property :duration do
            key :type, :integer
            key :format, :int64
          end
          property :marking do
            key :type, :string
          end
          property :other do
            key :type, :string
          end
          property :send_to do
            key :type, :string
          end
        end
      end
    end
  end
end
