require 'tasks/standalone_migrations'
require 'rspec/core/rake_task'

StandaloneMigrations::Configurator.environments_config do |env|
  env.on "production" do
    if (ENV['DATABASE_URL'])
      require 'uri'
      db = URI.parse(ENV['DATABASE_URL'])
      return {
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
      }
    end
    nil
  end
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "-c"
end
