# Règles de design frontend

Ces règles s'appliquent à **tout fichier `.html`, `.scss`, `.css`, `.component.ts`, ou fragment de UI** créé ou modifié dans ce repo. Elles définissent un design cohérent, maintenable et accessible pour l'application Angular.

## 1. Design system implicite

Le projet suit un thème **sci-fi / cyberpunk minimaliste** :
- Palette sombre par défaut.
- Accent néon/cyan ou magenta selon le contexte (défini dans les variables SCSS).
- Typographie monospace ou sans-serif condensée pour les éléments techniques.
- Formes géométriques, bordures fines, effets de glow légers.

Tout nouveau composant doit s'inscrire dans ce langage visuel sans le copier mécaniquement.

## 2. Variables et tokens

- Toutes les valeurs visuelles (couleurs, espacements, tailles de police, ombres, rayons) doivent passer par des **variables SCSS/CSS** ou des **CSS custom properties**.
- Ne pas coder de valeurs brutes (`#00ffff`, `16px`, `1rem`) directement dans les composants sauf exception justifiée.
- Tokens principaux attendus :
  - `--color-bg`, `--color-surface`, `--color-text`, `--color-text-muted`
  - `--color-accent`, `--color-accent-secondary`, `--color-danger`
  - `--space-xs`, `--space-sm`, `--space-md`, `--space-lg`, `--space-xl`
  - `--font-base`, `--font-mono`, `--font-size-xs` à `--font-size-xl`

## 3. Layout et responsive

- Utiliser **Flexbox** ou **CSS Grid** pour les layouts ; éviter les floats et les positions absolues sauf exception (overlay, tooltip).
- Concevoir d'abord en **mobile-first** : le composant doit être utilisable sur 320px.
- Tester les breakpoints courants : 360px, 768px, 1024px, 1440px.
- Ne pas utiliser de largeurs fixes en px pour les conteneurs principaux ; préférer `min()`, `clamp()`, `%`, `fr`.

## 4. Composants et réutilisation

- Avant de créer un nouveau composant, vérifier s'il n'existe pas déjà dans `frontend/src/app/shared/`.
- Les composants doivent être **standalone** par défaut.
- Un composant = un dossier avec `.ts`, `.html`, `.scss`, `.spec.ts`.
- La logique métier reste dans les services ; le composant gère seulement l'affichage, le binding et les événements.

## 5. Espacement et hiérarchie

- Utiliser une **échelle d'espacement cohérente** (multiples de 4px ou 8px).
- Respecter la loi de proximité : les éléments liés sont plus proches que les groupes distincts.
- Laisser suffisamment d'air autour des éléments interactifs (min 44×44px pour les zones cliquables).

## 6. Typographie

- Utiliser au maximum **2 familles de police** : une de base + une monospace pour les données techniques.
- Hiérarchie claire : `h1` > `h2` > `h3` > body > caption.
- Longueur de ligne idéale : 45 à 75 caractères pour le corps de texte.
- Ne pas utiliser de tailles de police fixes inférieures à 12px.

## 7. États interactifs

- Tout élément interactif doit avoir des états visuels explicites :
  - **default**, **hover**, **focus**, **active**, **disabled**
- Les transitions doivent être courtes (150–300ms) et subtiles.
- Le focus doit être visible (ne pas supprimer `outline` sans remplacement).

## 8. Icônes et images

- Utiliser une bibliothèque d'icônes cohérente (par exemple Material Symbols ou une lib SVG maison).
- Toute icône doit avoir un texte alternatif ou être décorative avec `aria-hidden="true"`.
- Préférer les SVG aux images bitmap pour les icônes et logos.

## 9. Animations et effets

- Les animations doivent avoir un **but fonctionnel** (feedback, révélation, état) et non être décoratives pures.
- Respecter `prefers-reduced-motion`.
- Éviter les animations qui bloquent le thread principal (utiliser `transform` et `opacity`).
- Durée maximale recommandée : 500ms pour les micro-interactions, 1s pour les révélations.

## 10. Cohérence avec le backend

- Les états de chargement, d'erreur et de succès doivent être visuellement cohérents avec le reste de l'application.
- Les messages d'erreur doivent être compréhensibles par un humain (pas de codes HTTP bruts seuls).
- Les formulaires doivent refléter la validation côté backend avec des styles et messages cohérents.

## 11. Lint et vérification

- `ng lint` doit passer sans erreur.
- Les styles doivent être validés par le lint Angular / Stylelint si présent.
- Après modification d'un composant visuel, vérifier le rendu sur au moins 2 tailles d'écran.
