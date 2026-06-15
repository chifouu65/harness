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
- `docs/conventions-[STACK].md`
- `docs/rules-html-accessibility.md`
- `docs/rules-frontend-design.md`
- `docs/rules-component-libraries.md`
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

- Framework / librairie UI ([FRAMEWORK_FRONTEND]) et version.
- Bundler / builder ([BUILDER_FRONTEND]).
- Tests ([FRAMEWORK_TEST_FRONTEND]).
- Langage ([LANGAGE_FRONTEND]).
- Style ([CSS_FRONTEND]).
- Librairies de composants ([LIBRAIRIE_UI_1], [LIBRAIRIE_UI_2]).
- Librairies d'accessibilité ([LIBRAIRIE_A11Y]).
- Router, state management, formulaires, HTTP client.
- Fichiers de config clés (`package.json`, `[CONFIG_FRAMEWORK]`, `tsconfig.json`,
  `[CONFIG_LINT]`, `[CONFIG_TEST]`).

### 1.3 Stack backend

- Framework ([FRAMEWORK_BACKEND]) et version.
- Langage ([LANGAGE_BACKEND]).
- Tests ([FRAMEWORK_TEST_BACKEND]).
- Validation ([LIBRAIRIE_VALIDATION]).
- ORM / base de données ([ORM_BACKEND]).
- API style (REST, GraphQL, tRPC, etc.).
- Fichiers de config clés.

### 1.4 Librairies de composants déjà utilisées

Pour le frontend, identifie toutes les librairies UI déjà importées dans le code :

```bash
# Exemples d'exploration (adapter les chemins)
find [CHEMIN_FRONTEND]/src -type f \( -name "*.ts" -o -name "*.html" \) | head -50
grep -R "from '[@]?[LIBRAIRIE_UI]" [CHEMIN_FRONTEND]/src/ | head -20
grep -R "import.*\{.*\}.*from" [CHEMIN_FRONTEND]/src/app/shared | head -30
```

Mais surtout, **ne te limite pas aux imports dans le code source** :

1. Liste les dépendances dans `[CHEMIN_FRONTEND]/package.json` qui ressemblent à des
   librairies de composants.
2. Pour chaque librairie suspectée :
   - Lis `node_modules/<lib>/package.json` pour connaître la version, la description et
     l'entrypoint principal.
   - Explore `node_modules/<lib>/` pour identifier les modules/composants exposés :
     - `node_modules/<lib>/README.md`
     - `node_modules/<lib>/index.d.ts` ou le dossier de bundles du framework
     - `node_modules/<lib>/package.json` → champ `exports`
   - Cherche les imports existants dans `[CHEMIN_FRONTEND]/src` pour savoir quels composants
     sont déjà utilisés.
3. Pour chaque librairie confirmée, note :
   - **Nom et version**
   - **Installation** : commande d'install ou déjà présente ?
   - **Module(s) d'import**
   - **Composants clés disponibles**
   - **Composants déjà utilisés dans le projet**
   - **Règles d'utilisation**

### 1.5 Scripts npm/yarn/pnpm

Pour chaque sous-projet, liste les scripts disponibles (`package.json` → `scripts`).
Vérifie la présence de `lint`, `test`, `test:ci`, `build`, `start`, `format`.

### 1.6 Règles ESLint / Prettier / TypeScript

- Typage strict activé ?
- Règle contre les types implicites larges ?
- Prettier configuré ?
- Plugins d'accessibilité présents côté frontend ?

### 1.7 Git et CI/CD

- `.gitignore` existe-t-il ? Quels patterns manquants ?
- CI existante ?
- Hooks Git présents ?

### 1.8 Autres détections utiles

- Fichiers Docker.
- Variables d'environnement (`.env.example`).
- API exposées et ports.
- Endpoints existants.

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
- Commandes de test correctes.
- Détection du package manager.

### 3.4 Crée/adapte les règles spécialisées

En fonction de la stack détectée :
- `docs/rules-html-accessibility.md` → si frontend HTML.
- `docs/rules-frontend-design.md` → si frontend [CSS].
- `docs/rules-component-libraries.md` → SI une librairie de composants est détectée.
  Ce fichier est critique : il empêche les agents de recréer des composants maison quand
  une librairie appropriée existe déjà.
- `docs/rules-backend-[FRAMEWORK].md` → si backend.
- `docs/rules-api-contracts.md` → si API backend.
- `docs/rules-testing.md` → si besoin de stratégie de tests.

### 3.5 Met à jour `README.md`

- Liste les fichiers du harness présents.
- Mentionne la commande `/init-project` / `!init`.

### 3.6 `.gitignore`

Ajoute les patterns manquants pour la stack détectée.

---

## 4. Workflow d'initialisation

1. **Analyse** — collecte (§1).
2. **Rapport** — présente le résumé + écarts + recommandations (§2).
3. **Validation** — attends l'accord de l'utilisateur avant de modifier les fichiers du
   harness.
4. **Application** — modifie les docs et scripts (§3).
5. **Verify** — lance `bash scripts/verify.sh`.
6. **Commit** — `chore(docs): aligne le harness avec la stack détectée`.

---

## 5. Règles d'or

- **Ne modifie jamais la logique métier du projet** (controllers, services, composants,
  templates, styles) pendant une phase INIT. Tu touches uniquement aux fichiers du harness
  et à `.gitignore`.
- **Ne supprime aucun fichier du harness** sans accord explicite.
- **Documente les hypothèses** : si tu ne parviens pas à détecter quelque chose, dis-le.
- **Reste conservateur** : mieux vaut un harness incomplet qu'un harness faux.
