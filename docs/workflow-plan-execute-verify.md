# Workflow Plan → Execute → Verify

C'est le cœur du harness. Il transforme un agent « qui se déclare fini » en un agent dont
la fin de tâche est **vérifiée par une machine**, pas par lui-même.

## Pourquoi

Un agent IA livré à lui-même a tendance à : sur-estimer ce qu'il a fait, déclarer
« terminé » sans avoir lancé les tests, et accumuler du contexte jusqu'à dériver. Les
trois phases ci-dessous imposent un rythme et un **gate déterministe** à la fin.

> Principe : *un modèle moyen avec un bon harness bat un excellent modèle avec un mauvais
> harness.*

## Les trois phases

### 1. PLAN
Avant tout code. L'agent produit : objectif, fichiers concernés, approche par étapes,
risques, et **comment ce sera vérifié**. Pour un changement à fort impact, il attend une
validation humaine.

- Avec Claude : commande `/plan`.
- Avec Copilot : demander explicitement « Donne-moi d'abord un plan, sans coder » ou
  utiliser le snippet `!plan` dans Copilot Chat / l'éditeur.

### 2. EXECUTE
Implémentation par **petits incréments**. Un commit = un changement logique. On édite
l'existant plutôt que de recréer. Aucune suppression de fichier sans accord.

- Avec Claude : commande `/implement`.
- Avec Copilot : utiliser le snippet `!implement` pour obtenir le prompt structuré, ou
  demander « Implémente le plan validé, en suivant AGENTS.md ».

### 3. VERIFY — le gate
On lance `scripts/verify.sh` : **lint + test + build**. Tant qu'une étape échoue, la tâche
n'est PAS terminée. L'agent corrige et relance, ou signale un blocage. Une fois tout vert,
commit au format Conventional Commits.

- Avec Claude : commande `/verify`.
- Avec Copilot : il n'existe pas de slash command `/verify` natif. Utilise le snippet
  `!verify` dans Copilot Chat pour injecter la commande exacte, ou exécute manuellement
  `bash scripts/verify.sh` dans le terminal. L'agent Copilot doit rappeler cette commande
  à chaque fin de tâche.

## Règle d'or de la phase Verify

L'agent ne doit **jamais** écrire « c'est terminé » sans avoir réellement exécuté les
checks et rapporté leur sortie. La vérité vient de la sortie du script, pas de l'agent.

## Utilisation par agent

| Agent | Commande native | Substitut pour le workflow | Initialisation |
|---|---|---|---|
| Claude Code | `/plan`, `/implement`, `/verify` | directe | `/init-project` |
| GitHub Copilot | pas de slash commands custom | snippets `!plan`, `!implement`, `!verify`, `!dod`, `!commit`, `!init` dans `.vscode/harness.code-snippets` | `!init` |

Les snippets permettent de coller les prompts du harness dans Copilot Chat ou l'éditeur,
exactement comme les slash commands le font pour Claude.

## Initialisation du harness (`/init-project` / `!init`)

Avant de commencer à travailler sur un repo frais ou après un changement majeur de stack,
utilise `/init-project` (Claude Code) ou le snippet `!init` (Copilot Chat). Cette commande :

1. Détecte la stack réelle (frameworks, versions, package managers).
2. Identifie les librairies de composants et les composants shared existants.
3. Pour chaque librairie de composants, explore `node_modules/<lib>/` (package.json,
   README, exports, barrel files) pour lister les modules d'import et les composants clés.
4. Compare la codebase avec les docs du harness (`AGENTS.md`, `CLAUDE.md`,
   `.github/copilot-instructions.md`, `scripts/verify.sh`, `.gitignore`,
   `docs/rules-component-libraries.md`).
5. Propose un rapport d'écart et, après validation, applique les corrections.
6. Termine par un `bash scripts/verify.sh` pour garantir que le gate passe toujours.

C'est la commande de bootstrap du harness : elle évite que la documentation et la
structure du repo divergent.

## Gestion du contexte (bonus)

Pour les tâches longues : ne pas tout charger d'un coup. Injecter la doc/les specs
seulement quand une étape en a besoin (*progressive disclosure*), et résumer
périodiquement l'historique pour ne pas saturer la fenêtre de contexte.
