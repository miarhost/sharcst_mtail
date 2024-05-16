class ParseModelResponse
  self << class
    def parse(user_id)
      response = Webhooks::SuggestedCategories(user_id)
      res = []
      array_of_chunks = response.body.split('"response":')

      array_of_chunks.each { |x| res << x.split(',')[0] }
      text_response = res.map { |x| x.gsub!(/\W+/, '')}
      text_response.join(" ")
    end
  end
end
