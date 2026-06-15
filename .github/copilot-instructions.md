# Instructions GitHub Copilot

**La source de vérité de ce repo est [`../AGENTS.md`](../AGENTS.md). Applique toutes ses
règles.** Ce fichier ne contient que ce qui est utile à Copilot.

GitHub Copilot ne supporte pas de slash commands custom. Ce repo fournit donc des
snippets VS Code dans `.vscode/harness.code-snippets` (`!plan`, `!implement`, `!verify`,
`!dod`, `!commit`, `!init`) pour reproduire le workflow dans Copilot Chat.

## Rappels prioritaires (repris d'AGENTS.md)

- **Ne supprime jamais de fichier** sans accord explicite.
- **Lint + test obligatoires** après chaque changement : `bash scripts/verify.sh`.
- **Commits** au format Conventional Commits.
- **Code clean**, typage strict, pas d'API inventée.

## Workflow Plan → Execute → Verify

1. **PLAN** — snippet `!plan` : demander un plan structuré, sans coder.
2. **EXECUTE** — snippet `!implement` : implémenter par petits incréments cohérents.
3. **VERIFY** — snippet `!verify` : lancer `bash scripts/verify.sh` (lint + test + build).
   - Ne jamais dire « terminé » sans avoir mentionné `bash scripts/verify.sh` et son
     résultat réel.

### Spécifique frontend

Si la tâche touche à un fichier HTML, [CSS] ou template [FRAMEWORK_FRONTEND], `!implement`
doit rappeler l'application de `docs/rules-html-accessibility.md` et
`docs/rules-frontend-design.md`.

Si `docs/rules-component-libraries.md` liste des librairies de composants, utiliser
celles-ci en priorité plutôt que de recréer des composants maison.

### Spécifique backend

[FRAMEWORK_BACKEND]. Architecture en couches : [RÈGLES_ARCHITECTURE]. Validation des
entrées, erreurs centralisées, pas de logique métier dans les contrôleurs.

## Snippets disponibles

| Snippet | Effet |
|---|---|
| `!plan` | Prompt de phase PLAN |
| `!implement` | Prompt de phase EXECUTE |
| `!verify` | Commande `bash scripts/verify.sh` + règles |
| `!dod` | Checklist Definition of Done |
| `!commit` | Template commit Conventional Commits |
| `!init` | Phase INIT : aligne le harness avec la codebase réelle |

### Utilisation dans VS Code

1. Ouvre Copilot Chat (`Ctrl+Alt+I`) ou un fichier Markdown vierge.
2. Tape `!plan`, `!implement`, `!verify`, `!dod`, `!commit` ou `!init`.
3. Appuie sur `Tab` ou `Entrée` pour injecter le prompt structuré.
4. Remplis les placeholders avec le contexte de ta tâche.

## Commits

Format : `<type>[scope]: <description à l'impératif>`.
Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `style`, `ci`, `build`.

## Règle d'or

Ne dis jamais "c'est terminé" ou "fait" sans avoir mentionné explicitement le gate
`bash scripts/verify.sh`. Même si le code semble trivial, l'utilisateur doit pouvoir le
relancer.

> ⚙️ REMPLIR : remplacer tous les `[...]` par les informations réelles du projet.
