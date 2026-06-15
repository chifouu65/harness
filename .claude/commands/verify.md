---
description: Phase VERIFY — gate déterministe : lint, test, build, Definition of Done, puis commit conventionnel.
type: agent-command
scope: project
---

# Phase VERIFY

Tu es en **phase VERIFY** du harness. Cette phase est un **gate déterministe** : tant que
`scripts/verify.sh` ne sort pas en code 0, la tâche n'est **pas** terminée.

## Procédure obligatoire

1. **Avant de lancer**, lis `AGENTS.md` §7 (Definition of Done).
2. Exécute exactement :
   ```bash
   bash scripts/verify.sh
   ```
   Si le fichier n'existe pas, lance les commandes équivalentes :
   - lint : `[COMMANDE_LINT_FRONTEND]` et `[COMMANDE_LINT_BACKEND]`
   - test : `[COMMANDE_TEST_FRONTEND]` et `[COMMANDE_TEST_BACKEND]`
   - build : `[COMMANDE_BUILD_FRONTEND]` et `[COMMANDE_BUILD_BACKEND]`
3. Rapporte le résultat **réel** de chaque étape :
   - ✅ `lint OK`
   - ✅ `test OK`
   - ✅ `build OK`
   - ❌ sinon, indique précisément quelle étape échoue et le message d'erreur.
4. Si une étape échoue :
   - corrige ;
   - relance `bash scripts/verify.sh` ;
   - répète jusqu'à succès ou jusqu'à 3 tentatives.
5. Une fois le script en code 0, coche mentalement la Definition of Done de `AGENTS.md` §7.
6. Crée le(s) commit(s) au format Conventional Commits :
   ```bash
   git add -p
   git commit -m "[type]([scope]): [description impérative]"
   ```

## Règles de commit

- Un commit = un changement logique.
- Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `style`, `ci`,
  `build`.
- Description en minuscule, sans point final, ≤ 72 caractères.
- Scope : nom du domaine ou du sous-projet (ex. `[SCOPE]`).

## Règle d'or

**Tu n'as pas le droit d'écrire « terminé » ou « fait » tant que `scripts/verify.sh` n'est
pas passé avec succès.** Même si le code semble trivial, le gate est la seule source de
vérité.

## En cas de blocage

Après 3 échecs de correction, arrête et expose clairement :
- le dernier message d'erreur ;
- ce que tu as déjà tenté ;
- ce que tu recommandes (changement de scope, aide humaine, etc.).
