# AGENTS.md — Source de vérité du harness

> Ce fichier est la **référence unique** pour tout agent IA travaillant sur ce repo
> (GitHub Copilot, Claude, Cursor, etc.). `CLAUDE.md` et
> `.github/copilot-instructions.md` ne font que pointer ici. **Ne dupliquez pas les
> règles** : modifiez-les ici, une seule fois.

## 1. Contexte projet

- **Nom** : Portfolio / Harness (vitrine personnelle sci-fi).
- **Architecture** : monorepo simple à deux sous-projets dans le même repo :
  - `frontend/` : application Angular 21 (standalone, SCSS, Vitest via `@angular/build:unit-test`).
  - `backend/` : API NestJS 11 (TypeScript, contrôleurs/services/modules, données mockées).
- **Langage** : TypeScript strict partout. Pas de `.js` à la racine du code source.
- **Gestionnaire de paquets** : `pnpm` pour le frontend ; `npm` pour le backend (documenté séparément).
- **API** : le frontend appelle `http://localhost:3000/api/*` (proxy Angular vers le backend en dev).
- **Port par défaut** : frontend `4200`, backend `3000`.

## 2. Règles absolues (non négociables)

1. **Ne jamais supprimer de fichier** sans demande explicite de l'utilisateur — aucun
   `.dll`, image, vidéo, ou tout autre type. En cas de doute, demander.
2. **Toujours lint + test** après toute feature/patch/fix avant de considérer la tâche
   terminée. Voir `scripts/verify.sh`.
3. **Toujours commiter** avec la convention Conventional Commits (voir §6).
4. **Code clean** : lisible, typé, sans code mort, sans `console.log` oubliés.
5. **Ne pas inventer d'API.** Si une lib/un endpoint est incertain, vérifier la doc
   réelle (fichiers du repo, types, doc officielle) avant d'écrire le code.
6. **Secrets** : jamais en clair dans le code ou les commits. Utiliser `.env` (gitignored).

## 3. Workflow obligatoire : Plan → Execute → Verify

Tout changement non trivial (≥ 3 étapes ou touchant plusieurs fichiers) suit ce cycle.
Détail complet dans `docs/workflow-plan-execute-verify.md`.

1. **PLAN** — Avant de coder : lister les fichiers à toucher, l'approche, les risques,
   et comment ce sera vérifié. Attendre validation si l'impact est important.
   - Avec Claude : `/plan`.
   - Avec Copilot : snippet `!plan` ou demande « plan sans coder ».
2. **EXECUTE** — Implémenter par petits incréments cohérents. Un commit = un changement
   logique.
   - Avec Claude : `/implement`.
   - Avec Copilot : snippet `!implement`.
3. **VERIFY** — Lancer `scripts/verify.sh` (lint + test + build). Ne **jamais** se
   déclarer « terminé » si une étape échoue. Si bloqué, le dire explicitement.
   - Avec Claude : `/verify`.
   - Avec Copilot : snippet `!verify` ou exécution manuelle de `bash scripts/verify.sh`.

Cette boucle est ce qui distingue un agent fiable d'une démo : la phase Verify est un
**gate déterministe**, pas une auto-évaluation de l'agent.

## 3bis. Commandes et snippets disponibles

| Agent | Mécanisme | Plan | Execute | Verify | Definition of Done | Commit |
|---|---|---|---|---|---|---|
| Claude Code | slash commands (`.claude/commands/*.md`) | `/plan` | `/implement` | `/verify` | non applicable | manuel ou guidé par `/verify` |
| GitHub Copilot | VS Code snippets (`.vscode/harness.code-snippets`) | `!plan` | `!implement` | `!verify` | `!dod` | `!commit` |

Les snippets permettent de coller les prompts du harness dans Copilot Chat ou l'éditeur,
exactement comme les slash commands le font pour Claude.

## 4. Conventions de code

Référence détaillée : `docs/conventions-angular-express.md` (à renommer
`conventions-angular-nestjs.md` si le projet stabilise sur NestJS). En résumé :

**Frontend (Angular / HTML / SCSS)**
- En plus des conventions générales, tout fichier HTML, SCSS ou template Angular est
  soumis aux règles de :
  - `docs/rules-html-accessibility.md` (a11y)
  - `docs/rules-frontend-design.md` (design system, tokens, responsive)
- Composants standalone par défaut. Un composant = un dossier (`.ts`, `.html`, `.scss`,
  `.spec.ts`).
- Logique métier dans des **services** injectables, pas dans les composants.
- Utiliser les Signals / `async` pipe pour l'état réactif ; éviter les souscriptions
  manuelles non désabonnées.
- Pas de logique dans les templates au-delà du binding simple.

**Commun (TypeScript)**
- `strict: true` dans tous les `tsconfig.json`. Pas de `any` implicite.
- Nommage : `camelCase` (variables/fonctions), `PascalCase` (classes/types/composants),
  `UPPER_SNAKE_CASE` (constantes globales).
- Fonctions courtes, une responsabilité. Pas de fonction > ~50 lignes sans raison.
- Gestion d'erreur explicite : pas de `catch` vide, pas d'erreur avalée.

**Angular**
- Composants standalone par défaut. Un composant = un dossier (`.ts`, `.html`, `.scss`,
  `.spec.ts`).
- Logique métier dans des **services** injectables, pas dans les composants.
- Utiliser les Signals / `async` pipe pour l'état réactif ; éviter les souscriptions
  manuelles non désabonnées.
- Pas de logique dans les templates au-delà du binding simple.

**Express / Node / NestJS**
- Architecture en couches : `routes` → `controllers` → `services` → `repositories`
  (NestJS : les routes sont définies par les décorateurs de `controllers/` ; les
  modules dans `*.module.ts` assurent le câblage).
- Validation des entrées à la frontière (ex. `zod`/`class-validator`) avant la logique.
- Erreurs centralisées via un **exception filter** NestJS unique ou middleware
  d'erreur Express. Codes HTTP corrects.
- Pas de logique métier dans les routes/contrôleurs ; les contrôleurs ne font que
  lire la requête, appeler un service et formater la réponse.
- Données mockées : les `*.data.ts` servent de repository temporaire. Ne pas les
  enrichir de logique métier.

## 5. Structure attendue

```
backend/                  → API NestJS 11 (TypeScript)
  src/
    app.*                 → module/contrôleur/service racine
    main.ts               → point d'entrée NestFactory
    types/                → DTO et interfaces partagées
    <feature>/            → un dossier par domaine
      *.controller.ts     → routes/décorateurs Nest
      *.service.ts        → logique métier
      *.module.ts         → déclaration du module
      *.data.ts           → données mockées (repository temporaire)
      *.controller.spec.ts→ tests unitaires du contrôleur
frontend/                 → Angular 21
  src/app/
    core/                 → services singleton, intercepteurs, guards
    shared/               → composants/pipes/directives réutilisables
    features/<feature>/   → un dossier par fonctionnalité
      *.ts, *.html, *.scss, *.spec.ts
```

## 6. Commits (Conventional Commits)

Format imposé :

```
<type>[scope optionnel]: <description courte à l'impératif>

[corps optionnel : pourquoi, pas comment]

[footer optionnel : BREAKING CHANGE, refs tickets]
```

Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `style`, `ci`,
`build`. Description en minuscule, sans point final, ≤ 72 caractères.

Exemples :
- `feat(auth): ajoute le refresh token côté Express`
- `fix(user-form): corrige la validation email côté Angular`

## 7. Definition of Done

Une tâche n'est terminée que si **toutes** ces cases sont cochées :

- [ ] Le code compile (`tsc` / `ng build` / `nest build` OK).
- [ ] Le lint passe sans erreur.
- [ ] Les tests passent ; un comportement nouveau a un test.
- [ ] Pas de fichier supprimé sans accord.
- [ ] Commit(s) au format Conventional Commits.
- [ ] Code clean : pas de `console.log`/`debugger`/code mort.
- [ ] Le gate `bash scripts/verify.sh` sort en code 0.
