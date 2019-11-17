module Swapi
  class SearchCharacters
    def send_request(search_term = nil, page = nil)
      connection = Faraday.new(url: "https://swapi.co/api/people/")
      res = connection.get do |req|
        req.params[:search] = search_term if search_term.present?
        req.params[:page] = page if page.present?
      end

      if res.success?
        return JSON.parse(res.body)
      else
        puts "Error: #{res.status}, #{res.reason_phrase}"
        return { results: [] }
      end
    end
  end
end
