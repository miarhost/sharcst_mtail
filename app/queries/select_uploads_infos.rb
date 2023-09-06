class SelectUploadsInfos
  def initialize(relation = UploadsInfo)
    @relation = relation
  end

  def call(params = nil)
    params.blank? ? @relation.all : search_filters(@relation, params)
  end

  def search_filters(relation, params)
    relation = by_user(relation, params)
    relation = by_number_of_seeds(relation, params)
    relation = by_protocol(relation, params)
    relation = by_upload_name(relation, params)
    relation
  end

  private

  def by_user(relation, params)
    relation.where(user_id: params[:user_id]).order(name: :asc)
  end

  def by_number_of_seeds(relation, params)
    relation.where(number_of_seeds: params[:number_of_seeds]).order(number_of_seeds: :desc)
  end

  def by_protocol(relation, params)
    relation.where(protocol: params[:protocol]).order(name: :asc)
  end

  def by_upload_name(relation, params)
    relation.joins(:upload).where('uploads.name = ?', params[:name])
  end
end
