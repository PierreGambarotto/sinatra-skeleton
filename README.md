Squelette pour application Sinatra/ActiveRecord
===============================================

## Arborescence des fichiers:

* `lib` : le code de votre application
* `lib/models` : la partie métier de votre application
* `views` : les différentes vues (templates) de votre application
* `views/layout.erb` : exemple de layout, utilisant la librairie CSS [Twitter
Bootstrap](http://twitter.github.com/bootstrap/)
* `examples` : des exemples listés dans cette documentation
* `spec` : spécifications rspec de votre application
* `db` : tout ce qui concerne la base de données (configuration, migrations)
* `app.rb` : le fichier de lancement de l'application.
* `demo.rb` : application de démonstration
* `Gemfile` : spécification des librairies utilisées

## Lancement de l'application de démo

```bash

sudo apt-get install libpq-dev # pour la gem pq
bundle install # installation des gems
ruby demo.rb # lance l'application sur http://localhost:4567
```

## Gestion de l'authentification

Nous allons considérer 2 types d'authentifications possibles:

* authentification pour API Rest
* authentification pour interface web

### Authentification pour API Rest

Une API Rest doit être sans état, ce qui implique de ne pas gérer de session. Le
client doit donc soumettre ses identifiants à chaque connexion.

Pour authentifier les appels par API, nous allons utiliser l'authentification
[HTTP
Basic](http://fr.wikipedia.org/wiki/HTTP_Authentification#M.C3.A9thode_Basic)
qui utilise l'entête `Authorization`.

Vous trouverez un exemple de code dans
[`examples/http_basic.rb`](examples/http_basic.rb).

### Authentification pour l'interface web

Pour gérer l'authentification, nous allons utiliser un service externe. Le
middleware Rack [`omniauth`](https://github.com/intridea/omniauth) permet de manière
souple l'utilisation de plusieurs sources d'authentification.

Il faut d'abord configurer `omniauth` en installant et configurant les
librairies spécifiques aux fournisseurs d'authentification (twitter, facebook,
google …).

Quel que soit le fournisseur d'authentification, l'utilisation est :

1. `GET '/auth/:provider'`
Le navigateur de l'utilisateur  est redirigé vers le service d'authentification
designé par `:provider`, qui se charge d'authentifier l'utilisateur.
2. Le service redirige ensuite le navigateur vers `/auth/:provider/callback`. La
   libraire omniauth remplit `request.env['omniauth.auth']` avec des
   informations représentant l'utilisateur, telle que l'email, le nom, et
   d'autres informations que vous trouverez dans la [spécification du hash
   renvoyé par
   omniauth](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema). En cas d'échec de
   l'authentification, le service redirige le navigateur vers `auth/failure`.
3. À vous de jouer pour faire quelque chose de ces informations, par exemple: 
  * créer un utilisateur dans une base de données 
  * positionner dans la session une variable pour se souvenir que l'utilisateur
  s'est authentifié

Vous trouverez un exemple d'utilisation dans `authentication.rb` et `demo.rb`.

### Distinguer les appels vers l'API Rest des appels vers l'interface web

Dans certains cas, l'utilisation de l'entête `Accept` ne suffit pas à distinguer
les appels pour l'interface web des appels API.

Le cas classique est la génération de html (donc `Accept: text/html`), avec :

* un document HTML complet pour l'interface web (layout + contenu)
* un fragment HTML pour l'API (juste le contenu sans enrobage).

Dans ce cas, il faut utiliser un autre entête :
* les clients javascripts positionnent fréquemment l'entête non standard `X-Requested-With:
XMLHttpRequest`. L'usage est tellemente courant que `Rack::Request#xhr?` existe.
* si votre API nécessite une authentification HTTP Basic, vous pouvez vérifier
la présence de l'entête `Authorization`.

Dans votre code, `request.xhr?` vaudra `true` si l'entête est positionné.

## Code source comportant de l'UTF-8, mettre en début de fichier

    # encoding: utf-8

Notez que la version 2.0 de ruby en fait un réglage par défaut.
   

## Environnements

Test, développement, production

### Positionner l'environnement courant

    export RACK_ENV = test | production | development

L'environnement par défaut est `development`.

## Migration

`rake -T db` va vous lister les tâches disponibles pour gérer vos bases de
données.

Les tâches s'appliquent dans l'environnement courant, ou `development` par
défaut.

## générer une migration

    rake db:new_migration name=do_this
   
Cette commande génère le fichier `db/migrate/YYYMMDDHHMMSS_do_this.rb` dans le
répertoire `db/migrate`
(`YYYMMDDHHMMSS` : date au format année mois jour heure minute seconde).

## appliquer les migrations

    rake db:migrate

## Appendices : plugins sinatra

Regarder du côté de sintra-contrib : http://www.sinatrarb.com/contrib/
en particulier : 

* [Sinatra::Json](http://www.sinatrarb.com/contrib/json.html) 
* [Sinatra::RespondWith](http://www.sinatrarb.com/contrib/respond_with.html)
* [Sinatra::Reloader](http://www.sinatrarb.com/contrib/reloader)

L'application `demo.rb` fournit un exemple d'utilisation de ces 3 modules.

## Simuler une requête PUT/DELETE à partir d'un navigateur

Le principe est de faire générer au navigateur une requête POST avec un
paramètre indiquant le type de requête HTTP souhaitée.

```html
<form action="…" method="POST">
  <input type="hidden" name="_method" value="PUT/DELETE"/>
  …
  <input type="submit" name="submit" value="ok"/>
</form>
```

Le middleware
[`Rack::MethodOverride`](http://rack.rubyforge.org/doc/classes/Rack/MethodOverride.html)
implémente le changement de requête: si une requête de type POST est reçue avec
le paramètre `_method`, alors le type de requête est changé pour la valeur du
paramètre `_method`.

Pour utiliser ce middelware, il faut dans Sinatra faire :

    enable :method_override # activé par défaut

Vous trouverez un exemple démontrant ce mécanisme dans
`examples/method_override.rb`


