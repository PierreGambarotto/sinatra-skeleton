# encoding: utf-8
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/multi_route'
require 'omniauth'

class Credentials
  def self.valid?(login, password)
    '12345' == password
  end
end
module AuthenticationHelpers
  def api?
    request.xhr? || request.accept.include?("application/json")
  end

  def current_user
    session['current_user']
  end

  def http_basic_credentials
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials ? @auth.credentials : nil
  end

  def authenticate!
    if api?
      login, pass = http_basic_credentials
      halt 401 unless Credentials.valid?(login,pass)
      session['current_user'] = login
    end
    unless current_user
      session['initial_request_path'] = request.path
      redirect '/login'
    end
  end
end
class Authentication < Sinatra::Base
  register Sinatra::MultiRoute
  enable :sessions, :logging
  configure :production do
    require 'omniauth-openid'
    require 'openid/store/filesystem'
    # fournisseur openid de Google, route : /auth/google
    use OmniAuth::Strategies::OpenID, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
    set :auth_provider, "google"
  end

  configure :development, :test do
    register Sinatra::Reloader
    use OmniAuth::Builder do
      provider :developer
    end
    set :auth_provider, "developer"
  end

  set :environment, ENV['RACK_ENV'] || :development

  helpers AuthenticationHelpers
  get '/login' do
    redirect "/auth/#{settings.auth_provider}"
  end
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end

  get '/logout' do
    session['current_user'] = nil
    redirect '/'
  end

  route :get, :post, '/auth/:provider/callback' do
    auth = request.env['omniauth.auth'] # hash given by the authentication provider
    session['current_user'] = auth.uid
    @debug = "Connexion réussie. <br/>Information collectées par le fournisseur d'authentification : #{auth.to_hash}"
    initial_request = session['initial_request_path']
    session['initial_request_path'] = nil
    redirect initial_request || '/'
  end
  run! if app_file == $0 
end
