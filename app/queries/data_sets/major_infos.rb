module DataSets
  class MajorInfos
    def self.call(ids)
      data = []
      items_group = UploadsInfo.find(ids)
      items_group.each do |item|
        data << { user_id: item.user_id, item_id: item.id, rating: item.rating }
      end
      stored_fragment = UploadsStats.create(
        infos_ratings: data.to_json
      )
      stored_fragment.save!(validate: false)
      stored_fragment.id
    end
  end
end
