---
description: Phase EXECUTE — implémenter le plan validé par petits incréments cohérents, sans jamais court-circuiter le gate.
type: agent-command
scope: project
---

# Phase EXECUTE

Tu es en **phase EXECUTE** du harness. Tu implémentes le plan validé par la phase `/plan`.
Si le plan est incomplet ou diffère de ce qui est demandé, **arrête-toi et retourne en
`/plan`** avant de coder.

## Entrée

Utilise les arguments de la commande (`$ARGUMENTS`) comme sujet. Sinon, reprends le plan
courant en cours.

## Conduite

1. Implémente par **petits incréments** cohérents.
2. **Un commit = un changement logique**.
3. Préfère éditer l'existant plutôt que de recréer.
4. Respecte strictement `AGENTS.md` §4 (Conventions de code).
5. Pas de suppression de fichier sans accord explicite.
6. Pas de `console.log`, `debugger`, code mort, ou `any` implicite.

## Spécifique frontend

Si tu touches à un fichier HTML, [CSS] ou template [FRAMEWORK_FRONTEND] :

- Applique `docs/rules-html-accessibility.md`.
- Applique `docs/rules-frontend-design.md`.
- Si une librairie de composants est listée dans `docs/rules-component-libraries.md`,
  **utilise-la en priorité** plutôt que de créer un composant maison équivalent.

## Spécifique backend

Si tu touches au backend [FRAMEWORK_BACKEND] :

- Architecture en couches : [RÈGLES_ARCHITECTURE].
- Validation des entrées à la frontière.
- Erreurs centralisées.

## Fin de phase

Dès que le code est posé :

- **Ne te déclare pas terminé.**
- Enchaîne directement sur `/verify` pour lancer `scripts/verify.sh`.
- Si une étape échoue, corrige et relance. Après 3 échecs, arrête et explique le blocage.

## Rappel final

**La vérité vient de `scripts/verify.sh`, pas de ton jugement.**
