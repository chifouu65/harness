---
description: Phase INIT — analyser le repo existant et aligner la documentation du harness avec la codebase réelle.
type: agent-command
scope: project
---

# Phase INIT

Tu es en **phase INIT** du harness. Cette commande est conçue pour être lancée une fois au
début, ou après un changement majeur de stack, afin d'aligner `AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md` et les règles spécialisées avec le projet réel.

**Objectif :** détecter automatiquement la stack technique, les librairies, les composants
existants et la structure de dossiers, puis proposer/correctionner la documentation du
harness.

---

## 0. Prérequis

Avant de commencer, lis les fichiers existants du harness :
- `AGENTS.md`
- `CLAUDE.md`
- `.github/copilot-instructions.md`
- `docs/conventions-angular-express.md` (ou équivalent)
- `docs/rules-html-accessibility.md`
- `docs/rules-frontend-design.md`
- `scripts/verify.sh`
- `README.md`

---

## 1. Analyse du repo

Inspecte la codebase et collecte les informations suivantes :

### 1.1 Structure générale

- Type de monorepo / repo simple.
- Langages principaux et versions approximatives.
- Sous-projets détectés (frontend, backend, mobile, etc.) et leurs emplacements.
- Gestionnaire(s) de paquets (`npm`, `pnpm`, `yarn`, `poetry`, etc.).

### 1.2 Stack frontend

- Framework / librairie UI (Angular, React, Vue, Svelte, etc.) et version.
- Bundler / builder (Vite, Webpack, esbuild, Angular CLI, etc.).
- Tests (Jest, Vitest, Karma, Playwright, Cypress, etc.).
- Langage (TypeScript, JavaScript, JSX, TSX).
- Style (SCSS, CSS, Tailwind, styled-components, CSS-in-JS, etc.).
- Librairies de composants (Angular Material, PrimeNG, shadcn/ui, Radix, Chakra, etc.).
- Librairies d'accessibilité (`@angular-eslint/template/accessibility-*`, axe-core, etc.).
- Router, state management, formulaires, HTTP client.
- Fichiers de config clés (`package.json`, `angular.json`, `vite.config.ts`, `tsconfig.json`,
  `eslint.config.*`, `jest.config.*`, `playwright.config.*`).

### 1.3 Stack backend

- Framework (NestJS, Express, Fastify, Django, FastAPI, etc.) et version.
- Langage (TypeScript, JavaScript, Python, etc.).
- Tests (Jest, Vitest, pytest, unittest, etc.).
- Validation (class-validator, zod, joi, pydantic, etc.).
- ORM / base de données (Prisma, TypeORM, Mongoose, SQLAlchemy, etc.).
- API style (REST, GraphQL, tRPC, etc.).
- Fichiers de config clés (`package.json`, `tsconfig.json`, `nest-cli.json`,
  `eslint.config.*`, `jest.config.*`, `prisma/schema.prisma`, etc.).

### 1.4 Librairies de composants déjà utilisées

Pour le frontend, identifie toutes les librairies UI déjà importées dans le code :

```bash
# Exemples d'exploration
find frontend/src -type f \( -name "*.ts" -o -name "*.html" \) | head -50
grep -R "from '@angular/material" frontend/src/ | head -20
grep -R "from 'primeng" frontend/src/ | head -20
grep -R "import.*\{.*\}.*from" frontend/src/app/shared | head -30
```

Mais surtout, **ne te limite pas aux imports dans le code source** :

1. Liste les dépendances dans `frontend/package.json` qui ressemblent à des librairies de
   composants (`@angular/material`, `primeng`, `ngx-bootstrap`, `@ng-bootstrap/ng-bootstrap`,
   `@nebular/theme`, `@progress/kendo-angular-*`, etc.).
2. Pour chaque librairie suspectée :
   - Lis `node_modules/<lib>/package.json` pour connaître la version, la description et
     l'entrypoint principal.
   - Explore `node_modules/<lib>/` pour identifier les modules/composants exposés :
     - `node_modules/<lib>/README.md`
     - `node_modules/<lib>/index.d.ts` ou `node_modules/<lib>/fesm2022/` (Angular)
     - `node_modules/<lib>/package.json` → champ `exports`
   - Cherche les imports existants dans `frontend/src` pour savoir quels composants sont
     déjà utilisés.
3. Pour chaque librairie confirmée, note :
   - **Nom et version**
   - **Installation** : `npm i`, `pnpm add`, déjà présente ?
   - **Module(s) d'import** : ex. `MatButtonModule`, `ButtonModule`
   - **Composants clés disponibles** : liste des 10–20 composants principaux
   - **Composants déjà utilisés dans le projet** : où et comment
   - **Règles d'utilisation** : standalone vs import dans module, style personnalisé
     autorisé ou non.

### 1.5 Mise à jour de `docs/rules-component-libraries.md`

Génère ou met à jour `docs/rules-component-libraries.md` avec les librairies détectées.

Format attendu par librairie :

```markdown
### @angular/material (v19.0.0)

- **Installée via** : `pnpm add @angular/material`
- **Importer** : `import { MatButtonModule, MatCardModule } from '@angular/material';`
- **Composants disponibles** : Button, Card, Dialog, Form Field, Input, Select, Table,
  Tabs, Toolbar...
- **Déjà utilisés dans le projet** : `MatButtonModule` dans `frontend/src/app/features/admin/admin.module.ts`
- **Règles** :
  - Utiliser les composants Material plutôt que des boutons/cards maison.
  - Respecter le thème Material ou le surcharger via les CSS custom properties du projet.
  - Importer uniquement les modules nécessaires (tree-shaking).
```

Ce fichier devient une **source de vérité sur les librairies de composants** : les agents
doivent le consulter avant d'ajouter un nouveau composant UI.

### 1.6 Intégration dans le reste du harness

Après avoir identifié les librairies de composants :

- Mentionne-les dans `AGENTS.md` §1 (Contexte projet) ou §4 (Conventions).
- Mentionne-les dans `CLAUDE.md` (spécifique frontend).
- Mentionne-les dans `.github/copilot-instructions.md` (Angular).
- Assure-toi que `docs/rules-frontend-design.md` ne contredit pas les guidelines de la
  librairie détectée.
- Si une librairie impose un design system fort (Material, Nebular, etc.), adapte les
  règles de tokens et de composants dans `docs/rules-frontend-design.md`.

### 1.5 Scripts npm/yarn/pnpm

Pour chaque sous-projet, liste les scripts disponibles :

```bash
cat frontend/package.json | grep -A 30 '"scripts"'
cat backend/package.json | grep -A 30 '"scripts"'
```

Vérifie la présence de `lint`, `test`, `test:ci`, `build`, `start`, `format`.

### 1.6 Règles ESLint / Prettier / TypeScript

- `strict: true` activé ?
- `@typescript-eslint/no-explicit-any` à `off`, `warn` ou `error` ?
- Prettier configuré ?
- Plugins Angular / accessibility présents côté frontend ?

### 1.7 Git et CI/CD

- `.gitignore` existe-t-il ? Quels patterns manquants (`node_modules`, `dist`, `.angular`, `.env`) ?
- CI existante (GitHub Actions, GitLab CI, etc.) ?
- Hooks Git présents ?

### 1.8 Autres détections utiles

- Fichiers Dockerfile / docker-compose.
- Variables d'environnement (`.env.example`).
- API exposées et ports (backend `main.ts`, `app.listen`, etc.).
- Endpoints existants (controllers, routes).

---

## 2. Rapport d'analyse

Produis un rapport structuré en 5 sections :

1. **Résumé exécutif** — stack détectée en 3–5 lignes.
2. **Sous-projets et stack détaillée** — tableau par projet.
3. **Écarts détectés** — différences entre la documentation actuelle du harness et la
   codebase.
4. **Librairies de composants UI** — liste des librairies et composants déjà utilisés.
5. **Recommandations de mise à jour** — fichiers du harness à modifier, avec les changements
   précis.

---

## 3. Mise à jour du harness

### 3.1 Met à jour `AGENTS.md`

Corrige au minimum :
- §1 Contexte projet (nom, stack, package managers, ports, API).
- §4 Conventions de code (frontend + backend).
- §5 Structure attendue (arborescence réelle).
- Mentionne les règles spécialisées applicables (`docs/rules-*.md`).

### 3.2 Met à jour `CLAUDE.md` et `.github/copilot-instructions.md`

- Stack détectée.
- Package manager et commandes exactes.
- Tests par projet.
- Règles frontend a11y/design si le frontend existe.

### 3.3 Met à jour `scripts/verify.sh`

- Liste des sous-projets détectés.
- Commandes de test correctes (`ng test --watch=false`, `jest`, `vitest`, etc.).
- Détection du package manager.

### 3.4 Crée/adapte les règles spécialisées

En fonction de la stack détectée :
- `docs/rules-html-accessibility.md` → si frontend HTML/Angular.
- `docs/rules-frontend-design.md` → si frontend SCSS/CSS/Angular.
- `docs/rules-component-libraries.md` → SI une librairie de composants est détectée.
  Ce fichier est critique : il empêche les agents de recréer des composants maison quand
  une librairie appropriée existe déjà.
- `docs/rules-backend-nestjs.md` → si NestJS.
- `docs/rules-api-contracts.md` → si API backend.
- `docs/rules-testing.md` → si besoin de stratégie de tests.

### 3.5 Met à jour `README.md`

- Liste les fichiers du harness présents.
- Mentionne la commande `/init-project`.

### 3.6 `.gitignore`

Ajoute les patterns manquants pour la stack détectée :
- `node_modules/`, `dist/`, `build/`, `.env`
- `.angular/` pour Angular
- `.next/`, `.nuxt/`, `.svelte-kit/` selon le framework
- fichiers IDE, logs, coverage

---

## 4. Workflow d'initialisation

1. **Analyse** — collecte (§1).
2. **Rapport** — présente le résumé + écarts + recommandations (§2).
3. **Validation** — attends l'accord de l'utilisateur avant de modifier les fichiers du
   harness.
4. **Application** — modifie les docs et scripts (§3).
5. **Verify** — lance `bash scripts/verify.sh` pour s'assurer que le gate passe toujours.
6. **Commit** — `chore(docs): aligne le harness avec la stack détectée`.

---

## 5. Règles d'or

- **Ne modifie jamais la logique métier du projet** (controllers, services, composants,
  templates, styles) pendant une phase INIT. Tu touches uniquement aux fichiers du harness
  et à `.gitignore`.
- **Ne supprime aucun fichier du harness** sans accord explicite.
- **Documente les hypothèses** : si tu ne parviens pas à détecter quelque chose, dis-le.
- **Reste conservateur** : mieux vaut un harness incomplet qu'un harness faux.

---

## 6. Exemple de sortie attendue

```markdown
## Résumé
Repo détecté : monorepo Angular 21 + NestJS 11, pnpm frontend / npm backend.
Frontend : tests Vitest via `@angular/build:unit-test`, SCSS, pas de lib de composants externe.
Backend : Jest, pas d'ORM détecté.

## Écarts
- `AGENTS.md` mentionne encore Express au lieu de NestJS.
- `scripts/verify.sh` ne détecte pas `--watch=false` pour Vitest/Angular.
- `.gitignore` manque `.angular/`.

## Recommandations
1. Mettre à jour `AGENTS.md` §1 et §4.
2. Corriger `scripts/verify.sh` ligne 94.
3. Ajouter `.angular/` à `.gitignore`.
4. Créer `docs/rules-backend-nestjs.md`.

Valide ces recommandations pour que je les applique.
```
