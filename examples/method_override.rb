# encoding: utf-8
require 'sinatra'

# enable :method_override # activé par défaut

get '/' do
  erb :index
end

delete '/delete_action' do
  @method = env['REQUEST_METHOD']
  @param = params[:param]
  erb :delete
end
__END__

@@ index
Formulaire HTML générant une requête POST, avec un paramètre caché _method valant DELETE

<form action="delete_action" method="POST">
  <input type="hidden" name="_method" value="DELETE"/>
  <input type="text" name="param"/>
  <br/>
  <input type="submit" name="submit" value="ok"/>
</form>

@@ delete
Requête reçue de type <%= @method %>
<br/>
Paramètre reçue: param=<%= @param %>

