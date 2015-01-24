require 'astronomy_engine/version'
require 'sinatra'
require 'astronomy'
require 'sinatra/json'

module AstronomyEngine
  class App < Sinatra::Base
    helpers Sinatra::JSON

    set :astronomy, Astronomy::Information.new
    before { content_type 'application/json' }

    get '/categories' do
      json settings.astronomy.categories
    end

    get '/categories/*/topics' do
      result = settings.astronomy.topics(params['splat'].first)

      return [404, 'Invalid category'] if result.nil?
      json result
    end

    get '/topics' do
      return [400, 'Must specify a search term `q`'] if params['q'].nil?
      return [400, 'Please specify a valid value for `q`'] if params['q'].strip.empty?

      json settings.astronomy.search(params['q'].strip)
    end
  end
end
