module SwagDocs
  class CatStatWithRecsModel
    include Swagger::Blocks

    swagger_schema :CatStatWithRecsModel do
      key :required, [:recs_stat, :related_topics]
      property :recs_stat do
        key :type, :object
        key :properties, [:uploads_recs, :infos_ratings, :user_ids]
      end
      property :related_topics do
        key :type, :array
      end
    end
  end
end
