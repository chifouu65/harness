# Règles de design frontend

Ces règles s'appliquent à **tout fichier `.html`, `[CSS]`, composant frontend, ou fragment
de UI** créé ou modifié dans ce repo.

> ⚙️ REMPLIR : adapter au design system du projet (tokens, typographie, palette, etc.).

## Design system

- Le projet utilise un design system **[NOM_DU_DESIGN_SYSTEM]**.
- Objectif visuel : **[OBJECTIF_VISUEL]**.
- Ne pas introduire de nouveaux styles contradictoires avec le design system existant.

## Tokens

Définir et utiliser des CSS custom properties pour :
- les couleurs ;
- les espacements ;
- les rayons de bordure ;
- les ombres ;
- les tailles de police ;
- les breakpoints.

Exemple de structure attendue :

```css
:root {
  --color-bg: [VALEUR];
  --color-text: [VALEUR];
  --color-primary: [VALEUR];
  --space-sm: [VALEUR];
  --space-md: [VALEUR];
  --radius: [VALEUR];
}
```

## Layout

- Mobile-first, responsive.
- Utiliser les composants/layouts du framework ([FRAMEWORK_FRONTEND]) ou du design system.
- Éviter les valeurs magiques ; préférer les tokens.

## Composants

- Vérifier `docs/rules-component-libraries.md` avant de créer un composant maison.
- Un composant = une responsabilité.
- Séparer la structure, le style et la logique de présentation.

## Typographie

- Police(s) officielle(s) du projet : **[POLICES]**.
- Hiérarchie de tailles fixe (ex. `xs`, `sm`, `base`, `md`, `lg`, `xl`, `2xl`).

## États interactifs

- Tous les éléments interactifs ont des états `:hover`, `:focus`, `:active`, `:disabled` clairs.
- Le focus est visible et cohérent.

## Icônes

- Utiliser la librairie d'icônes du projet : **[LIBRAIRIE_ICONES]**.
- Fournir un texte alternatif quand l'icône porte du sens.

## Animations

- Fonctionnelles, pas décoratives au détriment de la lisibilité.
- Respecter `prefers-reduced-motion`.
