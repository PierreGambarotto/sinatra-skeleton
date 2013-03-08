ENV['RACK_ENV'] = 'test'
require_relative(File.join('..','app')
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
