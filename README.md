# Harness — config partagée Copilot + Claude

Un *harness* léger et réutilisable : un ensemble de fichiers d'instructions qui donnent à
**GitHub Copilot** et **Claude** le même cadre de travail sur tes projets
**[STACK_TECHNIQUE]**.

L'idée du harness engineering : la qualité d'un agent vient surtout de ce qui l'entoure
(règles, workflow, vérification déterministe), pas seulement du modèle. Ce dossier en est
la version « config » : à déposer dans n'importe quel repo.

## ⚠️ Branche template

Cette branche `template` contient le **squelette générique** du harness. Les valeurs
spécifiques (nom du projet, stack, ports, frameworks) sont remplacées par des placeholders
`[...]`. Lance `/init-project` (Claude) ou `!init` (Copilot) sur un repo cible pour
remplir automatiquement ces placeholders et générer la documentation adaptée.

Pour la version déjà remplie et fonctionnelle sur le projet de référence (Angular + NestJS),
voir la branche `main`.

## Ce que fait ce harness

- **Un workflow commun** : `Plan → Execute → Verify`, pour Claude comme pour Copilot.
- **Un gate déterministe** : `scripts/verify.sh` (lint + test + build).
- **Des commandes slash pour Claude** : `/plan`, `/implement`, `/verify`, `/init-project`.
- **Des snippets VS Code pour Copilot** : `!plan`, `!implement`, `!verify`, `!dod`, `!commit`, `!init`.
- **Des règles scopées** : accessibilité HTML, design frontend, librairies de composants.
- **Une commande d'initialisation** : détecte la stack réelle, les librairies UI, et aligne la documentation.

## Contenu

| Fichier | Rôle |
|---|---|
| `AGENTS.md` | **Source de vérité unique.** Toutes les règles vivent ici. |
| `CLAUDE.md` | Pointe vers `AGENTS.md` + spécifique Claude. Lu automatiquement par Claude. |
| `.github/copilot-instructions.md` | Pointe vers `AGENTS.md` + spécifique Copilot. Lu automatiquement par Copilot. |
| `.claude/commands/` | Commandes `/plan`, `/implement`, `/verify`, `/init-project` pour Claude. |
| `.vscode/harness.code-snippets` | Snippets `!plan`, `!implement`, `!verify`, `!dod`, `!commit`, `!init` pour VS Code / Copilot Chat. |
| `docs/workflow-plan-execute-verify.md` | Le workflow central, détaillé. |
| `docs/conventions-[STACK].md` | Conventions de code détaillées. |
| `docs/rules-html-accessibility.md` | Règles a11y strictes pour tout HTML/template. |
| `docs/rules-frontend-design.md` | Règles design system, tokens, responsive pour le frontend. |
| `docs/rules-component-libraries.md` | Librairies de composants détectées par `/init-project` / `!init` (règles d'usage). |
| `scripts/verify.sh` | Gate déterministe : lint + test + build. |

## Table des commandes / snippets

| Phase | Claude | Copilot |
|---|---|---|
| Plan | `/plan` | `!plan` |
| Execute | `/implement` | `!implement` |
| Verify | `/verify` | `!verify` |
| Definition of Done | intégrée à `/verify` | `!dod` |
| Commit | guidé par `/verify` | `!commit` |
| Init / alignement | `/init-project` | `!init` |

## Installation dans un projet

1. Copie le **contenu** de ce dossier `harness/` à la **racine de ton repo** (pas le
   dossier `harness/` lui-même) :
   ```
   AGENTS.md
   CLAUDE.md
   .github/copilot-instructions.md
   .claude/commands/...
   .vscode/harness.code-snippets
   docs/...
   docs/rules-html-accessibility.md
   docs/rules-frontend-design.md
   docs/rules-component-libraries.md
   scripts/verify.sh
   ```
2. Lance `/init-project` (Claude) ou `!init` (Copilot Chat) pour détecter automatiquement
   la stack, les librairies de composants (avec inspection de `node_modules/`), les scripts
   et la structure, et aligner les docs du harness avec le repo.
3. Adapte `scripts/verify.sh` aux noms de tes sous-projets et de tes scripts npm
   (`lint`, `test`, `build`) si l'init ne l'a pas fait automatiquement.
4. Vérifie que `docs/rules-component-libraries.md` reflète bien les librairies UI et les
   modules d'import à utiliser.
5. Commite : `chore: ajoute le harness agents (config Copilot + Claude)`.

## Utilisation

- **Initialisation** : lance `/init-project` (Claude) ou `!init` (Copilot) pour aligner le
  harness avec la stack réelle du repo, notamment les librairies de composants.
- **Copilot** lit `.github/copilot-instructions.md` automatiquement (suggestions + Chat).
  Utilise les snippets `!plan`, `!implement`, `!verify`, `!dod`, `!commit`, `!init` dans
  Copilot Chat ou l'éditeur pour appliquer le cycle.
- **Claude** lit `CLAUDE.md` automatiquement. Utilise les commandes `/plan`,
  `/implement`, `/verify`, `/init-project` pour suivre le cycle.
- Les deux convergent vers `AGENTS.md` : **une seule règle à modifier** quand tu changes
  une convention.

## Le principe à retenir

Toute tâche non triviale suit **Plan → Execute → Verify**, et ne se termine que quand
`scripts/verify.sh` sort en code 0. C'est ce gate déterministe qui rend les agents
fiables plutôt qu'« impressionnants en démo ».

## ⚙️ À remplir avant la première utilisation

Avant de lancer `/init-project`, tu peux déjà renseigner à la main :

- `[NOM_DU_PROJET]`, `[FRAMEWORK_FRONTEND]`, `[FRAMEWORK_BACKEND]` dans `AGENTS.md`.
- Les ports et l'URL de l'API dans `AGENTS.md`.
- Les commandes de test dans `scripts/verify.sh`.
- Les règles spécifiques dans `docs/conventions-[STACK].md`.

Ensuite, `/init-project` complètera automatiquement les informations manquantes et
génèrera `docs/rules-component-libraries.md`.

> ⚙️ REMPLIR : adapter tous les `[...]` de ce README au projet cible.
