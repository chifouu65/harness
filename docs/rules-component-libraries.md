# Règles d'utilisation des librairies de composants

Ce fichier est **généré et maintenu par `/init-project`**. Il liste les librairies de
composants détectées dans le repo, les composants disponibles, et les règles d'importation.

**Règle d'or :** si une librairie de composants est listée ici, elle doit être utilisée en
priorité. On ne recrée pas un composant maison équivalent sans justification.

## Librairies détectées

<!-- /init-project remplit cette section automatiquement -->

_Aucune librairie de composants détectée lors de la dernière initialisation._

## Comment ajouter / mettre à jour

Lance `/init-project` dans Claude Code. La commande va :

1. Scanner `package.json` du frontend.
2. Identifier les dépendances commençant par des préfixes connus (`@angular/material`,
   `primeng`, `ngx-`, `@progress/kendo-`, `@nebular`, `@ng-bootstrap`, etc.).
3. Lire `node_modules/<lib>/package.json` et les exports principaux.
4. Lister les modules/composants exposés.
5. Réécrire cette section avec les informations utiles.

## Règles générales

- Toujours préférer un composant de la librairie existante à un composant maison.
- Lire la doc officielle ou le README dans `node_modules/<lib>/README.md` si l'API est
  incertaine.
- Importer les modules nécessaires dans le composant ou le `*.module.ts` concerné ; ne pas
  importer toute la librairie si seuls quelques composants sont utilisés.
- Respecter le thème du projet quand une librairie impose son propre design system.
