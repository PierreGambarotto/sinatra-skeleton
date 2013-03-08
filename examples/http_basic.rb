# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'

before '/http_basic_protected' do
  halt [ 401,
    { 'Content-Type' => 'text/plain',
      'Content-Length' => '0',
      'WWW-Authenticate' => "Basic realm=test" },
    []
  ] unless http_basic_credentials && valid_authentication?(http_basic_credentials)
end


def http_basic_credentials
  @auth ||= Rack::Auth::Basic::Request.new(request.env)
  @auth.provided? && @auth.basic? && @auth.credentials ? @auth.credentials : nil
end

def valid_authentication?(*credentials)
  login, password = credentials
  # insert validation code here
  "secret" == password
end

get '/http_basic_protected' do
  http_basic_credentials.inspect
end

