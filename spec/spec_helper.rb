ENV['RACK_ENV'] = 'test'
require_relative(File.join('..','app'))
require 'rack/test'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end if defined?(ActiveRecord::Base)
  end
end
