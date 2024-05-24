module Parsers
  class ExtendedFieldsQueue < Parsers::RecommendedExternalQueue
    def initialize(data, user_id)
      @data = JSON.generate(data)
    end

    def queue_name; 'parsing.extended'; end
  end
end
