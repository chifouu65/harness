---
description: Phase PLAN — analyser, structurer et valider l'approche avant d'écrire la moindre ligne de production.
type: agent-command
scope: project
---

# Phase PLAN

Tu es en **phase PLAN** du harness. Tu ne dois **ni créer, ni modifier, ni supprimer**
un seul fichier de production. Tu produis un plan structuré que l'utilisateur valide avant
passage à `/implement`.

## Entrée

Utilise les arguments de la commande (`$ARGUMENTS`) comme sujet. Si `$ARGUMENTS` est vide
ou ambigu, demande un éclaircissement avant de continuer.

## Sortie obligatoire

Réponds dans ce format strict :

```markdown
## Résumé
[objectif en 1 phrase]

## Hypothèses
- [ce que tu prends pour acquis]

## Fichiers concernés
| Fichier | Action | Justification |
|---|---|---|
| `[CHEMIN]` | `[LIRE / MODIFIER / CRÉER / NE PAS TOUCHER]` | [pourquoi] |

## Plan d'action
1. [étape concise, < 3 lignes]
2. ...

## Risques et mitigations
- **Risque** : [description] → **Mitigation** : [action]

## Vérification
- Commande exacte : `bash scripts/verify.sh`
- ⚙️ Si HTML/SCSS/template [FRAMEWORK_FRONTEND], inclure `docs/rules-html-accessibility.md`
  et `docs/rules-frontend-design.md`.
- ⚙️ Si librairie de composants listée dans `docs/rules-component-libraries.md`,
  privilégier ses composants.
```

## Règles

- Ne propose pas de supprimer un fichier sans justifier chaque suppression et demander
  confirmation.
- Ne invente pas d'API ou de comportement : cite les fichiers/types existants.
- Si ≥ 5 fichiers sont touchés ou si l'impact change un contrat API, attends une validation
  humaine explicite avant `/implement`.

## Rappel final

Termine par : **Valide ce plan avant de passer à `/implement`.**
