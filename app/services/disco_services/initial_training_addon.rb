require 'matrix'
require 'tf-idf-similarity'
module DiscoServices
  class InitialTrainingAddon
    def initialize(class_name, field)
      @class_name, @field = class_name, field
    end

    def set_examples_for_a_record
      examples = []
      @class_name.first(3).pluck(:"#{@field}").each do |u|
        examples << TfIdfSimilarity::Document.new(u)
      end
      examples
    end

    def make_matrix
      model = TfIdfSimilarity::BM25Model.new(set_examples_for_a_record)
      matrix = model.similarity_matrix
      matrix
    end
  end
end
