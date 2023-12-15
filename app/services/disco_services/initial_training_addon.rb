require 'matrix'
require 'tf-idf-similarity'
# require 'ruby-svd' remove

module DiscoServices
  class InitialTrainingAddon
    def initialize(class_name, *args)
      @class_name, @field_1, @field_2 = class_name, args[0], args[1]
    end

    def set_examples_for_a_record
      examples = []
      @class_name.first(3).each do |u|
        examples << TfIdfSimilarity::Document.new(u.send(@field_1).to_s)
        if u.send(@field_2).present?
          examples << TfIdfSimilarity::Document.new(u.send(@field_2).to_s)
        end
      end
      examples
    end

    def rsv_matrix
      model = TfIdfSimilarity::BM25Model.new(set_examples_for_a_record)
      model.similarity_matrix
    end

    def lsv_matrix
      user_corpus = []
      User.first(3).each do |u|
        user_corpus << [u.id, u.subscription_ids.map(&:to_i)].flatten
      end
      infos_matrix = DiscoServices::InitialTrainingAddon.new(UploadsInfo, 'id', 'media_type').rsv_matrix
      user_matrix = Matrix[ user_corpus ]
      Matrix.diagonal(user_matrix, infos_matrix)
    end

    def recomposed_matrix
      Matrix.diagonal(rsv_matrix, lsv_matrix)
    end

    def decompose_m
      recomposed_convert = recomposed_matrix.to_a.transpose
      apply_to_lsa = SVDMatrix.new(2,2)
      apply_to_lsa.set_row(0, recomposed_convert[0])
      apply_to_lsa.set_row(1, recomposed_convert[1])
      lsa = LSA.new(apply_to_lsa)

      lsa.classify_vector(rsv_matrix.to_a).sort{|a,b| a<=>b}
    end

    def vector
      Vector[recomposed_matrix.to_a.transpose]
    end
  end
end
