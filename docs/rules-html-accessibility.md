# Règles d'accessibilité HTML (a11y)

Ces règles s'appliquent à **tout fichier `.html`, `.component.html`, template Angular, ou fragment de markup** créé ou modifié dans ce repo. Elles visent le niveau **AA du RGAA / WCAG 2.1** sans ajouter de complexité inutile.

## 1. Sémantique HTML

- Utiliser les balises sémantiques appropriées : `header`, `main`, `section`, `article`, `nav`, `aside`, `footer`, `h1`–`h6`, `button`, `a`, `label`, `ul`/`ol`/`li`.
- Ne pas utiliser `div` ou `span` là où une balise sémantique existe.
- La hiérarchie des titres (`h1` → `h2` → `h3`) doit être cohérente et sans saut (pas de `h1` suivi d'un `h3`).

## 2. Navigation au clavier

- Tout élément interactif doit être focusable et utilisable au clavier.
- Ne pas supprimer le `outline` au focus sans fournir un style de focus visible alternatif.
- Gérer explicitement les touches `Escape`, `Enter`, `Space`, `Tab`, `ArrowUp/Down` quand un composant le nécessite (menus, modales, listes).

## 3. Images et médias

- Toute image informative doit avoir un `alt` descriptif.
- Les images décoratives doivent avoir `alt=""` (pas d'`alt` absent, pas de texte décoratif).
- Éviter les images de texte ; si impossible, reproduire le texte dans un attribut `alt` ou à proximité.

## 4. Formulaires

- Chaque champ `input`, `select`, `textarea` doit être associé à un `label` via `for` + `id`, ou `aria-labelledby`, ou `aria-label` si le design l'impose.
- Les messages d'erreur doivent être liés au champ via `aria-describedby` ou `aria-errormessage`.
- Ne pas utiliser `placeholder` comme seule étiquette.

## 5. Contraste et lisibilité

- Le contraste texte/fond doit respecter un ratio minimum de **4.5:1** pour le corps de texte et **3:1** pour les gros textes (24px+ ou 18px+ gras).
- Les éléments interactifs (boutons, liens, icônes cliquables) doivent avoir un contraste minimum de **3:1** avec leur fond.
- Ne pas transmettre une information uniquement par la couleur (ajouter un texte, une icône, un motif ou un label).

## 6. ARIA — utilisation raisonnée

- **Première règle d'ARIA : ne pas utiliser ARIA** si une balise HTML sémantique suffit.
- Les rôles ARIA (`role="dialog"`, `role="tabpanel"`, etc.) doivent être justifiés.
- Les attributs `aria-*` doivent être cohérents et mis à jour (pas de `aria-expanded="false"` sur un élément ouvert).
- Les composants custom doivent implémenter les patterns ARIA correspondants (ex. `combobox`, `dialog`, `tabs`).

## 7. Structure de page

- Une seule balise `<main>` par page.
- Les régions de page (`header`, `main`, `footer`, `nav`, `aside`) doivent être présentes et identifiables.
- Ajouter `lang="fr"` (ou la langue réelle du contenu) sur `<html>`.

## 8. Mouvement et animations

- Respecter `prefers-reduced-motion` : désactiver ou réduire les animations pour les utilisateurs qui le demandent.
- Ne pas lancer d'animation, vidéo ou son automatiquement sans moyen de pause/contrôle.

## 9. Liens et boutons

- Un `<button>` déclenche une action dans la page ; un `<a>` mène vers une autre page ou ancre.
- Ne pas utiliser `<a>` sans `href` (sauf avec `role="button"` + gestion clavier justifiée).
- Le texte du lien doit être explicite hors contexte (éviter « cliquez ici », « en savoir plus » seul).

## 10. Tests et vérification

- Lancer le lint Angular accessibility : `@angular-eslint/template/accessibility-*` doit passer.
- Vérifier la navigation au clavier manuellement sur le composant modifié.
- S'il y a une animation/dépendance visuelle forte, tester avec `prefers-reduced-motion: reduce` activé.
