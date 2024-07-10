module DataSets
  class MajorInfos
    def self.call(ids, upl_id, fv_id)
      data = []
      items_group = UploadsInfo.find(ids)
      items_group.each do |item|
        data << { user_id: item.user_id, item_id: item.id, rating: item.rating }
      end
      stored_fragment = UploadsStat.create!(
        infos_ratings: data.to_json,
        upload_id: upl_id,
        folder_version_id: fv_id
      )
      stored_fragment.id
    end
  end
end
