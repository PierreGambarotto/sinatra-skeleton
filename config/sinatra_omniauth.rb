configure :production do
  require 'omniauth-inpt-oauth2'
  use OmniAuth::Builder do
    provider :inpt_oauth2, "9505ea9a727bd2d5495181b6ff81d5c674d75a0b67d58777bb54bc30ce249696", "2c8222c2db068ef428bf331693d5619d0bc140f892460525964463156b933ef4"
  end
  set :auth_provider, "inpt_oauth2"
end

configure :development, :test do
  use OmniAuth::Builder do
    provider :developer
  end
  set :auth_provider, "developer"
  register Sinatra::Reloader
end


