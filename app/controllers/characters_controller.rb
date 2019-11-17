class CharactersController < ApplicationController
  def index
    page = params[:page] || 1
    search_term = params[:search].to_s.strip
    swapi_request = Swapi::SearchCharacters.new
    swapi_response_body = swapi_request.send_request(search_term, page)
    @next_page_exists = swapi_response_body["next"].present?
    @characters = swapi_response_body["results"]
  end
end
