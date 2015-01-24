require 'astronomy_engine'
require 'capybara/rspec'

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before do
    Capybara.app = AstronomyEngine::App
  end
end