# CLAUDE.md

**La source de vérité de ce repo est [`AGENTS.md`](./AGENTS.md). Lis-le d'abord et
applique toutes ses règles.** Ce fichier ne contient que ce qui est spécifique à Claude.

## Avant de commencer

1. Lis `AGENTS.md` en entier.
2. Pour toute tâche non triviale, applique le cycle **Plan → Execute → Verify**
   (voir `docs/workflow-plan-execute-verify.md`).
3. Utilise les commandes dans `.claude/commands/` (`/plan`, `/implement`, `/verify`,
   `/init-project`).

## Rappels prioritaires (repris d'AGENTS.md)

- **Ne supprime jamais de fichier** sans accord explicite.
- **Lint + test obligatoires** après chaque changement : `bash scripts/verify.sh`.
- **Commits** au format Conventional Commits.
- **Code clean**, typage strict, pas d'API inventée.

## Spécifique Claude

- **Dépendances / package manager** : [npm / pnpm / yarn / ...] pour le frontend ;
  [npm / pnpm / yarn / ...] pour le backend.
- **Tests** : [FRAMEWORK_TEST_FRONTEND] côté frontend, [FRAMEWORK_TEST_BACKEND] côté backend.
- **API** : le backend expose [ENDPOINTS] ; le frontend consomme via [CLIENT_HTTP]
  avec [CONFIGURATION_PROXY/DIRECT].
- **Initialisation** : lance `/init-project` au premier usage du harness ou après un
  changement majeur de stack pour aligner les docs avec la codebase réelle, y compris les
  librairies de composants dans `docs/rules-component-libraries.md`.
- Quand tu modifies plusieurs fichiers, **annonce d'abord ton plan** (fichiers + approche)
  avant d'éditer, puis exécute.
- Préfère **éditer** les fichiers existants plutôt que d'en recréer.
- Termine toujours par la phase **Verify** : lance les checks et rapporte le résultat
  réel (ne déclare pas « terminé » sans avoir lancé `scripts/verify.sh`).
- Si une vérification échoue et que tu ne peux pas corriger, **dis-le clairement** plutôt
  que de contourner.
- Si tu utilises une lib dont l'API est incertaine, **consulte la doc**
  (types du repo, doc officielle) avant d'écrire.

> ⚙️ REMPLIR : remplacer tous les `[...]` par les informations réelles du projet.
