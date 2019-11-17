module Swapi
  class SearchCharacters
    def send_request(search_term = nil)
      connection = Faraday.new(url: "https://swapi.co/api/people/")
      res = connection.get do |req|
        req.params[:search] = search_term if search_term.present?
      end

      if res.success?
        return JSON.parse(res.body)
      else
        puts "Something went wrong. Res body: #{JSON.parse(res.body)}"
      end
    end
  end
end
