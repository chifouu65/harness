# Conventions Angular + Express/Node (TypeScript)

Détail des conventions résumées dans `AGENTS.md` §4. À adapter à ton projet réel.

## TypeScript (commun)

- `strict: true` dans tous les `tsconfig.json`. Pas de `any` implicite ; si `any` est
  inévitable, le commenter et l'isoler.
- Préférer `type`/`interface` explicites aux structures anonymes répétées.
- `const` par défaut, `let` si réassignation, jamais `var`.
- Imports triés et absolus quand un alias de chemin existe (`@app/...`, `@api/...`).
- Pas de `console.log` en production : utiliser un logger (ex. `pino` côté Node).

## Angular

**Structure**
```
src/app/
  core/        → services singleton, intercepteurs, guards (chargés une fois)
  shared/      → composants/pipes/directives réutilisables, sans état métier
  features/
    <feature>/ → un dossier par fonctionnalité (composants + services locaux)
```

**Composants**
- Standalone par défaut (`standalone: true`).
- Un composant = un dossier : `.ts`, `.html`, `.scss`, `.spec.ts`.
- `changeDetection: ChangeDetectionStrategy.OnPush`.
- Pas de logique métier dans le composant : déléguer aux **services**.
- État réactif via **Signals** ou `async` pipe. Éviter les `subscribe()` manuels ; si
  nécessaire, se désabonner (`takeUntilDestroyed`).
- Pas de logique dans les templates au-delà du binding et de simples conditions.

**Services**
- `@Injectable({ providedIn: 'root' })` pour les singletons.
- Les appels HTTP passent par des services dédiés, jamais directement dans un composant.

**Tests**
- Tests unitaires des services (logique) et des composants critiques (`.spec.ts`).

## Express / Node

**Architecture en couches**
```
src/
  routes/        → définition des endpoints, câblage uniquement
  controllers/   → lecture requête, appel service, formatage réponse
  services/      → logique métier
  repositories/  → accès données (DB, API externes)
  middlewares/   → auth, validation, gestion d'erreur
  types/         → DTO, interfaces partagées
```

**Règles**
- **Aucune logique métier dans les routes ni les contrôleurs** : elle vit dans les
  services.
- **Validation des entrées à la frontière** avec `zod` (ou `class-validator`) avant
  d'atteindre la logique. Rejeter tôt avec un 400 clair.
- **Gestion d'erreur centralisée** : un seul middleware d'erreur en fin de chaîne. Les
  couches lèvent des erreurs typées ; le middleware mappe vers le bon code HTTP.
- Codes HTTP corrects : 200/201/204, 400/401/403/404, 409, 422, 500.
- Pas de secret en dur : configuration via `process.env` validée au démarrage.
- Async/await partout ; jamais de promesse non gérée (`unhandledRejection`).

**Sécurité de base**
- `helmet`, `cors` configuré explicitement, rate limiting sur les routes sensibles.
- Ne jamais renvoyer la stack trace au client en production.

## Lint / format

- ESLint (`@typescript-eslint`) + Prettier. Le lint doit passer **sans erreur** avant
  commit (voir `scripts/verify.sh`).
