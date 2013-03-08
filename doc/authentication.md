`authentication.rb`
===================

Ce fichier implémente un Middleware Rack avec Sinatra.
Le but est de fournir une gestion d'authentification.

Le fichier fournit également des helpers pour utilisation dans votre application
sinatra.

3 environnements de configuration différents sont gérés : test, developement,
  production

## Utilisation

Pour utiliser le middleware dans votre application Sinatra :

```ruby

require 'authentication' # ou require_relative et adapter le chemin

use Authentication
```

Pour bénéficier des helpers, rajouter :

```ruby

helpers AuthenticationHelpers
```

## Description des routes gérées par le middleware

`GET /login` : rediriger le navigateur vers cette route entame le processus
d'authentification

`GET /logout` : déconnecte l'utilisateur.

`GET /auth/:provider` : redirige le navigateur de l'utilisateur vers le site
gérant l'authentication. La valeur de `:provider` varie en fonction de
l'environnement.

`GET/POST /auth/:provider/:callback` : le site ayant authentifié l'utilisateur
redonne la main à votre application en redirigeant le navigateur de
l'utilisateur vers cette route. Les paramètres de la requête offre une
description de l'utilisateur. Une librairie spécifique à chaque fournisseur
(`omniauth-nom_du_fournisseur`) se charge de décoder ces paramètres et de les
fournir dans `request.env['omniauth.auth']`.

## Description des helpers

Le module `AuthenticationHelpers` fournit :

* `api?` : renvoie true si la requête demande la partie API de votre
application. 

Détails d'implémentation :

`request.xhr?` : `true` si l'entête `X-Requested-With` vaut `XMLHttpRequest`.

* `current_user`
* `http_basic_credentials` : renvoie `[login, password]` si l'authentification
HTTP Basic a été utilisée
* `authenticate!` : vérifie l'authentification de l'utilisateur. C'est ce helper
que vous utiliserez dans votre code comme filtre sur les actions nécessitant une
authentification. 

La méthode `Credentials::valid?` implémente la vérification d'une identité
fournie par HTTP Basic. Il faudra surcharger cette implémentation dans votre
code.

## Configuration spécifique à chaque environnement

Les environnements `test` et `development` utilisent le fournisseur
d'authentification `developer`, qui présente un formulaire, mais accepte toutes
les valeurs fournies.

L'environnement `production` utilise le fournisseur openid de Google.

Les environnements sont définis dans les blocs `configure` au début de la classe
`Authentication`.

