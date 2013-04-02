# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/respond_with'
require 'sinatra/json'
require_relative './authentication'
use Authentication
helpers AuthenticationHelpers

set :environment, ENV['RACK_ENV'] || :development
before '/resource*' do
  logger.info("ressource protégée")
  authenticate!
end

get '/' do
  erb <<INDEX
<% if current_user %>
  Visualisez la resource <a href="/resource/foo" class="btn btn-primary">foo</a>
<% else %>
<div class="hero-unit">
  <h1>Sinatra Skeleton</h1>
  <p>Un squelette d'application sinatra</p>
  </p>
  <p>
    <a class="btn btn-primary btn-large" href='login' >
    Identifiez-vous pour accéder au reste de l'application
    </a>
  </p>
</div>
<% end %>

INDEX
end

get '/resource/:name', :provides => [:html, :json] do
  @resource = {name: params[:name]}
  respond_to do |format|
    format.html do
      erb <<SHOW
<p>La resource que vous contemplez est : <a href="" class="btn btn-success"><%= @resource[:name] %></a></p>

<p>Pour récupérer cette ressource par l'API Rest:</p>
<pre>curl -H "Accept: application/json" -u toto:12345 http://#{request.host}:#{request.port}/resource/#{params[:name]}</pre>

<p>L'API Rest est configurée pour laisser passer toutes les requêtes s'authentifiant avec HTTP Basic et le mot de passe '12345'
</p>
SHOW
    end
    format.json { json @resource }
  end
end
