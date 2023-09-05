class UploadsInfosSerializer < ActiveModel::Serializer
  attributes  :user_id, :upload_id, :protocol, :name, :media_type, :number_of_seeds,
              :provider, :duration, :description, :static_info_block
end
