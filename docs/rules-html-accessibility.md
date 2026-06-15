# Règles d'accessibilité HTML (a11y)

Ces règles s'appliquent à **tout fichier HTML, template, ou fragment de markup** créé ou
modifié dans ce repo.

> ⚙️ REMPLIR : ajouter des règles spécifiques au framework ([FRAMEWORK_FRONTEND]) si
> besoin.

## Sémantique

- Utiliser les balises sémantiques (`header`, `nav`, `main`, `section`, `article`, `footer`,
  `h1`–`h6`) pour structurer le document.
- Une seule balise `h1` par page.
- Ne pas sauter de niveaux de titres (`h1` → `h2` → `h3`).

## Navigation clavier

- Tout élément interactif doit être focusable et actionnable au clavier.
- Ordre de tabulation logique et visible.
- Gérer `Enter` / `Space` / `Escape` quand nécessaire.

## Images

- Toute image porteuse d'information a un `alt` descriptif.
- Les images décoratives utilisent `alt=""`.

## Formulaires

- Chaque champ a un `label` associé (`for` / `id` ou aria-labelledby).
- Les messages d'erreur sont reliés au champ via `aria-describedby`.
- Les regroupements utilisent `fieldset` + `legend`.

## Contraste et lisibilité

- Respecter les ratios de contraste WCAG 2.1 AA minimum.
- Ne pas se fier à la couleur seule pour transmettre une information.

## ARIA

- Utiliser ARIA avec parcimonie ; préférer la sémantique HTML native.
- Ne pas ajouter `role` redondants (`role="button"` sur un `button`).
- Maintenir `aria-*` cohérents avec l'état visuel.

## Animations

- Respecter `prefers-reduced-motion` pour les animations non essentielles.

## Tests

- Si un plugin d'accessibilité existe dans le projet (ex. [PLUGIN_A11Y]), l'activer.
- Vérifier manuellement la navigation clavier sur les nouveaux composants interactifs.
