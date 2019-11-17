class CharactersController < ApplicationController
  def index
    search_term = params[:search].to_s.strip
    swapi_request = Swapi::SearchCharacters.new
    swapi_response_body = swapi_request.send_request(search_term)
    @characters = swapi_response_body["results"]
  end
end
