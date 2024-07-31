class CatStatWithRecsSerializer < ActiveModel::Serializer
  attributes :recs_stat, :related_topics

  def recs_stat
    RecsStatAttrsSerializer.new(
      object.recommendations_stat,
      root: false
    )
  end
end
