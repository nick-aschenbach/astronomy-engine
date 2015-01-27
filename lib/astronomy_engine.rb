require 'astronomy_engine/version'
require 'astronomy'

require 'sinatra'
require 'sinatra/assetpack'
require 'sinatra/json'

module AstronomyEngine
  class App < Sinatra::Base
    helpers Sinatra::JSON
    register Sinatra::AssetPack

    set :root, File.join(File.dirname(__FILE__), 'public')
    set :astronomy, Astronomy::Information.new
    assets {
      serve '/js', from: 'js'
      serve '/css', from: 'css'
    }

    get '/' do
      content_type 'text/html'
      path = File.join(settings.root, 'index.html')
      send_file path
    end

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
