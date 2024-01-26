class FilterRecords
  def initialize(relation = UploadsInfo)
    @relation = relation
  end

  def call(params = nil)
    params.blank? ? @relation.all : search_filters(@relation, params)
  end

  def search_filters(relation, params)
    res = []
    params.each do |key, value|
       res << relation.where(:"#{key}" => value)
    end
    res
  end

  def by_name(relation, params)
    relation.joins(:upload).where('uploads.name ilike ?', "%#{params[:name]}%")
  end
end
