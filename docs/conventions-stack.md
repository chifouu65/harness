# Conventions de code

> ⚙️ REMPLIR : ce fichier est un squelette. Lancer `/init-project` pour le remplir
> automatiquement ou l'adapter à la main à la stack du projet.

## Langage

- [LANGAGE_PRINCIPAL] [VERSION]
- Typage strict activé.
- Pas de type implicite large.

## Frontend ([FRAMEWORK_FRONTEND])

- Composants standalone / structure attendue du framework.
- Logique métier dans des services/fonctions dédiés, pas dans les templates.
- Règles a11y : `docs/rules-html-accessibility.md`.
- Règles design : `docs/rules-frontend-design.md`.
- Librairies de composants : `docs/rules-component-libraries.md`.

## Backend ([FRAMEWORK_BACKEND])

- Architecture en couches : [RÈGLES_ARCHITECTURE_BACKEND].
- Validation des entrées à la frontière.
- Erreurs centralisées, codes HTTP corrects.
- Pas de logique métier dans les routes/contrôleurs.

## Tests

- [FRAMEWORK_TEST_FRONTEND] côté frontend.
- [FRAMEWORK_TEST_BACKEND] côté backend.
- Un nouveau comportement = un test.

## Nommage

- `camelCase` : variables, fonctions.
- `PascalCase` : classes, types, composants.
- `UPPER_SNAKE_CASE` : constantes globales.

## Commits

Format : `<type>[scope]: <description à l'impératif>`.
Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `style`, `ci`, `build`.
