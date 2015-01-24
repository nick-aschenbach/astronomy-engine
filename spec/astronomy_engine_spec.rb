require 'spec_helper'
require 'pry-nav'

describe AstronomyEngine::App do
  include Rack::Test::Methods

  def app
    AstronomyEngine::App
  end

  let(:astronomy_instance) { app.new.settings.astronomy }

  let(:sample_topic_data) {
    [{'name' => 'Brie', 'description' => 'A soft aged creamy spreadable cheese'},
     {'name' => 'Cheddar', 'description' => 'A yellow, sharp, hard cheese'},
     {'name' => 'Swiss', 'description' => 'A holey white cheese'}]
  }

  describe 'application configuration' do
    it 'sets an instance of Astronomy::Information to astronomy config setting' do
      expect(astronomy_instance.class).to eq(Astronomy::Information)
    end
  end

  describe 'get categories' do
    it 'delegates the request to the gem' do
      expect(astronomy_instance).to receive(:categories)

      get '/categories'
    end

    it 'returns successfully' do
      get '/categories'

      expect(last_response).to be_ok
    end

    it 'returns the correct body' do
      fake_categories = %w[apples pears bananas]
      allow(astronomy_instance).to receive(:categories).and_return(fake_categories)
      get '/categories'

      expect(JSON.parse(last_response.body)).to eq(fake_categories)
    end

    it 'renders the results as json' do
      get '/categories'

      expect(last_response.header['Content-Type']).to eq('application/json')
    end
  end

  describe 'get category topics' do
    let(:category) { 'cheese' }

    it 'delegates the request to the gem' do
      expect(astronomy_instance).to receive(:topics).with(category)

      get "/categories/#{category}/topics"
    end

    context 'when a valid category is passed in' do
      before do
        expect(astronomy_instance).to receive(:topics).with(category).and_return(sample_topic_data)
        get "/categories/#{category}/topics"

      end

      it 'returns successfully' do
        expect(last_response).to be_ok
      end

      it 'returns the correct body' do
        expect(JSON.parse(last_response.body)).to eq(sample_topic_data)
      end

      it 'returns the correct content type' do
        expect(last_response.header['Content-Type']).to eq('application/json')
      end
    end

    context 'when an invalid category is passed in' do
      before do
        allow(astronomy_instance).to receive(:topics).and_return(nil)
        get "/categories/#{category}/topics"
      end

      it 'returns a 404' do
        expect(last_response.status).to eq(404)
      end

      it 'returns a body with error message' do
        expect(last_response.body).to eq('Invalid category')
      end
    end
  end

  describe 'search topics' do
    context 'when the query string parameter is valid' do
      let(:q) { 'candy' }
      let(:endpoint_with_query_param) { "/topics?q=#{q}" }

      it 'ignores leading and trailing whitespace' do
        expect(astronomy_instance).to receive(:search).with('foo')

        get '/topics?q=%20%20%20%20%20%20%20%20%20%20foo%20%20%20%20%20'
      end

      it 'delegates the request to the gem' do
        expect(astronomy_instance).to receive(:search).with(q)

        get endpoint_with_query_param
      end

      it 'returns successfully' do
        get endpoint_with_query_param

        expect(last_response).to be_ok
      end

      it 'returns the correct body' do
        allow(astronomy_instance).to receive(:search).and_return(sample_topic_data)

        get endpoint_with_query_param
        expect(JSON.parse(last_response.body)).to eq(sample_topic_data)
      end

      it 'returns the correct content type' do
        get endpoint_with_query_param

        expect(last_response.header['Content-Type']).to eq('application/json')
      end
    end

    context 'when no search term is provided' do
      before { get '/topics' }

      it 'returns a 400' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a body with an error message' do
        expect(last_response.body).to eq('Must specify a search term `q`')
      end
    end

    context 'when it is an empty string' do
      before { get '/topics?q=' }

      it 'returns a 400' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a body with an error message' do
        expect(last_response.body).to eq('Please specify a valid value for `q`')
      end
    end

    context 'when it is just white space' do
      before { get '/topics?q=%20%20%20' }

      it 'returns a 400' do
        expect(last_response.status).to eq(400)
      end

      it 'returns a body with an error message' do
        expect(last_response.body).to eq('Please specify a valid value for `q`')
      end
    end
  end
end
