---
description: Phase PLAN — analyser, structurer et valider l'approche avant d'écrire la moindre ligne de production.
type: agent-command
scope: project
---

# Phase PLAN

Tu es en **phase PLAN** du workflow Plan → Execute → Verify.

**Règle absolue : n'écris, ne modifie et ne supprime aucun fichier de production pour le moment.**
Tu peux seulement lire le repo pour comprendre le contexte.

## Objectif

Produire un plan suffisamment précis pour que l'utilisateur valide ou corrige l'approche avant que le code soit touché.

## Entrée

La tâche demandée est dans `$ARGUMENTS`.
Si `$ARGUMENTS` est vide ou ambigu, pose des questions avant de continuer.

## Sortie attendue

Réponds en 6 sections obligatoires (numérotées) :

1. **Résumé de la tâche** — une phrase qui reformule l'objectif final.
2. **Hypothèses** — ce que tu considères comme vrai sans l'avoir vérifié (stack, API existante, comportement attendu).
3. **Fichiers concernés** — liste exhaustive avec, pour chacun, l'action : `LIRE`, `MODIFIER`, `CRÉER`, `NE PAS TOUCHER`.
4. **Plan d'action** — étapes numérotées, ordonnées, chacune < 3 lignes.
5. **Risques et mitigations** — effets de bord, régressions, points de vigilance.
6. **Vérification** — quels tests, lint, build, commandes exactes seront utilisés pour valider.
   Si le plan touche au frontend Angular ou à des fichiers HTML/SCSS, mentionne explicitement
   `docs/rules-html-accessibility.md` et `docs/rules-frontend-design.md`.

## Contraintes

- Si la tâche touche ≥ 5 fichiers ou change un contrat API, **attends explicitement la validation de l'utilisateur** avant de passer à `/implement`.
- Ne propose jamais de supprimer un fichier sans justifier le besoin et demander l'accord.
- N'invente pas d'API, de librairie ou de endpoint : si tu n'es pas sûr, marque-le comme hypothèse à vérifier.
- Termine ta réponse par :
  > Valide ce plan (`/implement <numéro de la tâche>`) ou corrige-le avant de continuer.

## Rappel

La source de vérité est `AGENTS.md`. En cas de conflit entre cette commande et `AGENTS.md`, `AGENTS.md` prime.
