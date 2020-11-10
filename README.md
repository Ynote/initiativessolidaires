> _Le dépôt distant `origin` de ce projet est maintenant migré sur https://gitlab.com/ynote_hk/initiativessolidaires._

![Deploy](https://github.com/Ynote/initiativessolidaires/workflows/Deploy/badge.svg)
# Inventaire collaboratif des cagnottes et initiatives solidaires

Ce projet propose une page recensant les cagnottes et initiatives solidaires à
travers la France. Il s'appuie sur le travail d'inventaire de
[@chloe.madesta](https://www.instagram.com/chloe.madesta/) et
[@queergouine](https://www.instagram.com/queergouine/) et est alimenté par toute
une communauté de façon collaborative.

Pour en savoir plus sur l'origine de cet inventaire, vous pouvez consulter [le
post sur le profil de @chloe.madesta](https://www.instagram.com/p/CHDOcDygLV-/)
sur Instagram.

- [Prérequis](#prérequis)
- [Développement](#développement)
  - [Pages du site](#pages-du-site)
  - [Intégration](#intégration)
  - [Génération de la page d'inventaire](#génération-de-la-page-dinventaire)
  - [Données en JSON](#données-en-json)
  - [Configuration avec Dotenv](#configuration-avec-dotenv)
- [Contribuer](#contribuer)
- [Remerciements](#remerciements)
- [Ressources](#ressources)

## Prérequis
- Ruby 2.6.3
- un compte Google et une clé d'API de projet sur Google API

## Motivation

Ce projet propose d'étendre l'accessibilité du Google Sheet initié par
[@chloe.madesta](https://www.instagram.com/chloe.madesta/) sur les internets.
En effet, dans l'optique de se soustraire à la domination des GAFAM sur le web,
il est extrêmement important de rendre disponibles des contenus riches et
diversifiés, présents sur ces plateformes, sur des pages web, navigables et
accessibles par toutes et tous.


## Développement

Le site déployé est statique, à l'exception d'un petit script pour faire
fonctionner le filtre de sélection. La page principale est générée dans un
dossier `dist`.

### Pages du site
Le script de génération de la page principale est en Ruby. Il est très basique
à escient et ne gère que cette page-là.

Si vous ajoutez d'autres pages au site, mettez-les dans
le dossier `dist`. Attention à bien reprendre la structure HTML de la page
principale et à mettre à jour les metas, ainsi que la navigation.

### Intégration
Pour le travail d'intégration, il n'est pas nécessaire de générer la page du
site. Vous pouvez coder à partir du fichier `dist/example.html`. Lorsque
l'intégration est prête, reportez vos modification sur le fichier
`src/templates/index.html`.

### Données en JSON
Les données de l'inventaire sont générées en JSON à partir du [Google Sheet
d'origine](https://docs.google.com/spreadsheets/d/1ITLeygBBuz2oq-FwjBda7V-amHGK191-pXLLo1R7px0/edit?usp=sharing)
sur lequel il y a une gestion de droits et d'historique. Il sert donc de base de
données pour ce site et n'est donc pas versionné.

Pour comprendre la structure de données, vous pouvez vous référer au fichier
`src/data/inventory_example.json`.

Les thématiques de l'inventaire sont listées dans un fichier JSON à part  pour
permettre leur personnalisation. Vous pouvez vous référer au fichier
`src/data/topics_example.json` pour en comprendre la structure de données.

### Installation

```sh
bundle install
```

### Génération de la page d'inventaire

Lancer :
```
bundle exec bin/build
```

### Configuration avec Dotenv

Pour pouvoir générer les fichiers JSON, il est nécessaire de renseigner la clé
d'API d'un projet Google API. Vous pouvez [créer un
projet](https://cloud.google.com/docs/authentication/api-keys) dans
https://console.developers.google.com et y associer une clé d'API spécifique pour
ce projet.

Vous devez renseigner les variables suivantes dans un fichier `.env` à la
racine du projet:
```
GOOGLE_SHEETS_API_KEY=***
GOOGLE_SPREADSHEET_ID=***
```
- **GOOGLE_SHEETS_API_KEY** : votre [clé d'API de projet Google](https://cloud.google.com/docs/authentication/api-keys)
- **GOOGLE_SPREADSHEET_ID** : l'id du document collaboratif Google Sheet

### Tests automatisés

Lancer :
```
bin/rspec
```

## Prochaines étapes
- Ajouter un filtre géographique
- Ajouter une barre de recherche (simple parsing du contenu du fichier JSON)
- Ajouter un formulaire pour soumettre une proposition qui s'ajouter
  automatiquement sur un des onglets du Google Sheets

## Contribuer

N'hésitez pas à contribuer sous forme de pull requests et issues. Des idées d'amélioration sur le design ou l'expérience sur le site sont les bienvenues !

Ce dépôt est sous la licence [Hippocratic License](https://firstdonoharm.dev/)
et se veut être un lieu ouvert et bienveillant de collaboration. Les personnes
voulant contribuer sont invitées à suivre la charte code de conduite du [Contributor
Covenant](https://www.contributor-covenant.org/fr/version/1/4/code-of-conduct/).

## Remerciements

Je remercie [@chloe.madesta](https://www.instagram.com/chloe.madesta/) et
[@queergouine](https://www.instagram.com/queergouine/) pour tout le travail de
contenu et de hiérarchisation, et pour leur énergie qui m'a inspirée pour
coder ce mini-site.

Je remercie également [@sunny](https://github.com/sunny/) pour ses revues de
code, son aide et son soutien pour la création de ce site.

## Ressources

- [Comment aider pendant le confinement ? _(Post Instagram)_](https://www.instagram.com/p/CHDOcDygLV-/)
- [Comment aider pendant le
  confinement ? _(Story Instagram)_](https://www.instagram.com/stories/highlights/18120957295152945/)
- [@chloe.madesta](https://www.instagram.com/chloe.madesta/)
- [@queergouine](https://www.instagram.com/queergouine/)
