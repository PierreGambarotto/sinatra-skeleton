require 'active_record'

config_file = File.join(File.dirname(__FILE__),"config.yml")

environment = ENV['RACK_ENV'] || 'development'
configuration = YAML.load(File.open(config_file))[environment]
Dir.chdir(File.join(File.dirname(__FILE__),'..'))

if environment == 'production' && ENV['DATABASE_URL']
  require 'uri'
  db = URI.parse(ENV['DATABASE_URL'])
  configuration = {
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :port     => db.port,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  }
end

ActiveRecord::Base.establish_connection(configuration)


