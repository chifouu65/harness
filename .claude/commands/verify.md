---
description: Phase VERIFY — gate déterministe : lint, test, build, Definition of Done, puis commit conventionnel.
type: agent-command
scope: project
---

# Phase VERIFY

Tu es en **phase VERIFY** du workflow Plan → Execute → Verify.

**C'est le gate final.** La tâche n'est terminée que si les vérifications passent réellement, pas parce que le code "semble bon".

## Procédure obligatoire

1. **Lance le gate principal**
   ```bash
   bash scripts/verify.sh
   ```
   S'il n'existe pas, exécute les équivalents projet par projet :
   - `npm run lint` / `pnpm run lint`
   - `npm test --silent` / `pnpm test --watch=false` / `ng test --watch=false`
   - `npm run build` / `pnpm run build` / `ng build` / `nest build`

2. **Rapporte le résultat réel**
   - Pour chaque étape, indique : ✅ OK ou ❌ ÉCHEC.
   - En cas d'échec, copie le **message d'erreur pertinent** (2–10 lignes max).

3. **Si une étape échoue**
   - Analyse la cause.
   - Corrige.
   - **Relance** `bash scripts/verify.sh`.
   - Répète jusqu'à ce que tout passe.
   - Ne **jamais** désactiver un check, ignorer un test ou contourner le gate.

4. **Definition of Done**
   Vérifie explicitement chaque item d'`AGENTS.md` §7 avant de continuer :
   - [ ] Compile (`tsc` / `ng build` / `nest build`)
   - [ ] Lint sans erreur
   - [ ] Tests passent ; nouveau comportement couvert par un test
   - [ ] Pas de fichier supprimé sans accord
   - [ ] Commit(s) au format Conventional Commits
   - [ ] Pas de `console.log`, `debugger`, code mort
   - [ ] `bash scripts/verify.sh` sort en code 0

5. **Commit**
   - Crée le(s) commit(s) au format Conventional Commits.
   - Exemples : `feat(profile): ajoute le endpoint list`, `fix(frontend): corrige le mock canvas`.

## En cas de blocage

Si après **3 tentatives** une vérification échoue toujours :
- **Arrête**.
- Explique le blocage précisément.
- Propose 2–3 options à l'utilisateur.
- Ne déclare **pas** la tâche terminée.

## Règle d'or

> Tu n'as pas le droit d'écrire "terminé", "fait", "OK" ou "c'est bon" tant que
> `bash scripts/verify.sh` ne retourne pas un succès documenté.
