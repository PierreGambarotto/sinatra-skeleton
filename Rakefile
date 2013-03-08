require 'tasks/standalone_migrations'

StandaloneMigrations::Configurator.environments_config do |env|
  env.on "production" do
    if (ENV['DATABASE_URL'])
      require 'uri'
      db = URI.parse(ENV['DATABASE_URL'])
      {
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :port     => db.port,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
      }
    else
      nil
    end
  end
end

environment = ENV['RACK_ENV'] || 'development'
if environment == 'development'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "-c"
  end
end
