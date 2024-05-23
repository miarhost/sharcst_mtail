module Webhooks
  class ParseModelResponse
    def self.parse(user_id)
      response = RedisData::CollectMistralResponses.call(user_id)
      res = []
      array_of_chunks = response.split('"response":')

      array_of_chunks.each { |x| res << x.split(',')[0] }
      text_response = res.map { |x| x.gsub!(/\W+/, '')}
      names = []
      text_response.each do |i|
        if i =~ /[0-9]/
          names << text_response[text_response.index(i) + 1, 6].join
        end
      end
      names&.map do |name|
        if name[1..-1][/[[:upper:]]/]
          index = name.split("")[1..-1].index { |ch| ch =~ /[[:upper:]]/}
          name.chomp!(name[index..-1])
        else
          name
        end
      end
      names.compact.uniq
    end
  end
end
