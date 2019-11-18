require "rails_helper"

describe CharactersController, type: :controller do
  let(:characters) { JSON.parse(file_fixture("swapi_characters.json").read) }

  describe "GET index" do
    context "with no search param and no page param" do
      let(:expected_characters) { characters[0..9] }
      let(:expected_body) {
        {
          "count" => 10,
          "next" => "https://swapi.co/api/people/?page=2",
          "previous" => nil,
          "results" => expected_characters
        }
      }

      before do
        stub_request(:get, "https://swapi.co/api/people/?page=1").
          to_return(status: 200, body: expected_body.to_json)
      end

      it "sets @characters to the first page of all characters" do
        get :index
        expect(assigns(:next_page_exists)).to eq(true)
        expect(assigns(:characters)).to eq(expected_characters)
      end
    end

    context "with search param but no page param" do
      let(:expected_characters) { [ characters[0], characters[10] ] }
      let(:expected_body) {
        {
          "count" => 2,
          "next" => nil,
          "previous" => nil,
          "results" => expected_characters
        }
      }
      let(:search_term) { "sky" }

      before do
        stub_request(:get, "https://swapi.co/api/people/?page=1&search=#{search_term}").
          to_return(status: 200, body: expected_body.to_json)
      end

      it "sets @characters to the first page of matching characters" do
        get :index, params: { search_term: search_term }
        expect(assigns(:next_page_exists)).to eq(false)
        expect(assigns(:characters)).to eq(expected_characters)
      end
    end

    context "without search param but with page param" do
      let(:expected_characters) { characters[10..16] }
      let(:expected_body) {
        {
          "count" => 17,
          "next" => nil,
          "previous" => "https://swapi.co/api/people/?page=1",
          "results" => expected_characters
        }
      }
      let(:page) { 2 }

      before do
        stub_request(:get, "https://swapi.co/api/people/?page=#{page}").
          to_return(status: 200, body: expected_body.to_json)
      end

      it "sets @characters to the correct page of all characters" do
        get :index, params: { page: page }
        expect(assigns(:next_page_exists)).to eq(false)
        expect(assigns(:characters)).to eq(expected_characters)
      end
    end

    context "with failed response" do
      let(:expected_body) { { error: "Some error" } }

      before do
        stub_request(:get, "https://swapi.co/api/people/?page=1").
          to_return(status: 500, body: expected_body.to_json)
      end

      it "sets @characters to empty array" do
        get :index
        expect(assigns(:next_page_exists)).to eq(false)
        expect(assigns(:characters)).to eq([])
      end
    end
  end
end
