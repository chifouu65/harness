---
description: Phase EXECUTE — implémenter le plan validé par petits incréments cohérents, sans jamais court-circuiter le gate.
type: agent-command
scope: project
---

# Phase EXECUTE

Tu es en **phase EXECUTE** du workflow Plan → Execute → Verify.

**Tu ne dois implémenter que le plan validé.** Si `$ARGUMENTS` contient un plan différent de celui qui a été validé, arrête-toi et demande confirmation.

## Principes d'exécution

1. **Un commit = un changement logique**.
   - Pas de commit fourre-tout.
   - Chaque commit doit pouvoir être expliqué en une phrase.
2. **Privilégie l'édition à la recréation.**
   - Ne supprime et recrée pas un fichier si une modification suffit.
3. **Ne supprime aucun fichier** sans accord explicite de l'utilisateur.
4. **Code clean par défaut** :
   - TypeScript strict, pas d'`any` implicite.
   - Pas de `console.log`, `debugger`, ni code mort laissé derrière.
   - Respecte `AGENTS.md` §4 et `docs/conventions-angular-express.md`.
5. **Vérifie au fur et à mesure.**
   - Après un changement risqué (typage, refactor, nouvelle dépendance), lance un check partiel (`tsc --noEmit`, `ng lint`, test ciblés) si pertinent.

## Règles spécifiques au frontend (Angular/HTML/SCSS)

Si le plan concerne le frontend (`frontend/`) ou touche à des fichiers `.html`, `.scss`,
`.component.ts` ou des templates Angular, applique **en plus** ces deux fichiers de règles :

- **Accessibilité HTML** : `docs/rules-html-accessibility.md`
  - Sémantique correcte, hiérarchie de titres, `alt` sur les images, labels sur les champs,
    contraste suffisant, navigation clavier, ARIA raisonnée, `prefers-reduced-motion`.
- **Design frontend** : `docs/rules-frontend-design.md`
  - Variables/tokens, layout responsive mobile-first, réutilisation des composants shared,
    espacement cohérent, typographie limitée, états interactifs explicites, animations
    fonctionnelles et respectueuses de `prefers-reduced-motion`.

Avant de soumettre un changement frontend, vérifier que `ng lint` et `ng build` passent
pour la partie concernée.

## Si le plan s'avère incomplet

- Signale-le immédiatement.
- Propose un ajustement **avant** de continuer.
- Si l'ajustement est majeur, retourne en phase `/plan`.

## Fin de phase

**Tu n'as PAS le droit de dire que la tâche est terminée.**
Dès que le code est posé, termine ta réponse par :

> Passage à la phase `/verify` pour valider avec `bash scripts/verify.sh`.

Ne lance pas toi-même `verify.sh` ici : c'est le rôle de `/verify`.
