class UploadsInfoSerializer < ActiveModel::Serializer
  attributes :user_id, :upload_id, :protocol, :name, :streaming_infos, :media_type, :number_of_seeds,
             :provider, :duration, :description, :static_info_block
end
