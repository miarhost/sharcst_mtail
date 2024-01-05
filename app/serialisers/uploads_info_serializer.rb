class UploadsInfoSerializer < ActiveModel::Serializer
  attributes :user_id, :upload_id, :log_tag, :name, :streaming_infos, :media_type, :rating,
             :provider, :duration, :description, :static_info_block
end
