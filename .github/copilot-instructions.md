# Instructions GitHub Copilot

**La source de vérité de ce repo est [`../AGENTS.md`](../AGENTS.md). Applique toutes ses
règles.** Ce fichier ne contient que ce qui est utile à Copilot.

GitHub Copilot lit automatiquement `.github/copilot-instructions.md` comme contexte pour
les suggestions et Copilot Chat. Garde ce fichier court : les détails sont dans
`AGENTS.md`.

## Règles à toujours respecter

- **Stack** : Angular 21 + NestJS 11 en **TypeScript strict**. Pas de `any` implicite.
- **Ne propose jamais de supprimer un fichier.**
- **Angular** : composants standalone, logique dans des services injectables, Signals /
  `async` pipe pour l'état, pas de logique lourde dans les templates.
  **Tout HTML/template Angular est soumis à `docs/rules-html-accessibility.md` et
  `docs/rules-frontend-design.md`.**
  **Si `docs/rules-component-libraries.md` liste des librairies de composants, utiliser
  celles-ci en priorité plutôt que de recréer des composants maison.**
- **NestJS** : contrôleurs/services/modules ; validation des entrées via
  `class-validator`/`class-transformer` si ajoutée ; exception filter centralisé.
- **Nommage** : `camelCase`, `PascalCase` (types/classes/composants), `UPPER_SNAKE_CASE`
  (constantes).
- **Gestion d'erreur explicite** : jamais de `catch` vide.
- **Pas de `console.log` ni `debugger`** dans le code livré.

## Workflow Plan → Execute → Verify

Toute tâche non triviale suit ce cycle. Aide l'utilisateur à le respecter.

### 1. PLAN (pas de code)

Quand on te demande une feature ou un fix, réponds d'abord par un plan structuré :

- **Objectif** — reformule la demande en une phrase.
- **Fichiers concernés** — liste les chemins exacts.
- **Approche** — étapes ordonnées.
- **Risques / points d'attention** — effets de bord, fichiers à ne pas toucher.
- **Vérification** — comment valider (tests, lint, build).

Tu peux injecter ce prompt rapidement avec le snippet `!plan`.

### 2. EXECUTE (implémenter)

Une fois le plan validé par l'utilisateur, implémente par petits incréments :

- Édite les fichiers existants, ne les recrée pas.
- Un commit logique à la fois.
- TypeScript strict, code clean, conventions du projet.

Snippet : `!implement`.

### Spécifique frontend

Si la tâche touche à un fichier HTML, SCSS ou template Angular, `!implement` doit rappeler
l'application de `docs/rules-html-accessibility.md` et `docs/rules-frontend-design.md`.

### 3. VERIFY (gate déterministe)

**Avant de déclarer quoi que ce soit terminé**, rappelle à l'utilisateur de lancer :

```bash
bash scripts/verify.sh
```

Ce script exécute : `lint` → `test` → `build` pour chaque sous-projet détecté
(backend, frontend). Tant qu'une étape échoue, la tâche **n'est pas terminée**.

Après un succès, crée le(s) commit(s) au format Conventional Commits.

Snippet : `!verify`.

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

> Les snippets sont dans `.vscode/harness.code-snippets`. Ils ne remplacent pas
> `AGENTS.md` : ils en sont une interface rapide pour Copilot, qui n'a pas de slash
> commands custom.

## Commits

Conventional Commits : `<type>(scope): description`. Types : `feat`, `fix`, `refactor`,
`test`, `docs`, `chore`, `perf`, `ci`, `build`.

## Tests & lint

Avant de proposer un changement comme terminé, rappeler de lancer le lint et les tests
(`npm run lint`, `npm test` / `ng test --watch=false` / `pnpm run lint`) — voir
`scripts/verify.sh`.

## Definition of Done

Compile + lint OK + tests OK + commit conventionnel + pas de code mort. (Détail dans
`AGENTS.md` §7.)

## Règle d'or

Ne dis jamais "c'est terminé" ou "fait" sans avoir mentionné explicitement le gate
`bash scripts/verify.sh`. Même si le code semble trivial, le gate est obligatoire.
