# AGENTS.md — Source de vérité du harness

> Ce fichier est la **référence unique** pour tout agent IA travaillant sur ce repo
> (GitHub Copilot, Claude, Cursor, etc.). `CLAUDE.md` et
> `.github/copilot-instructions.md` ne font que pointer ici. **Ne dupliquez pas les
> règles** : modifiez-les ici, une seule fois.
>
> ⚙️ REMPLIR : adapter toutes les sections entre `[...]` au projet cible.

## 1. Contexte projet

- **Nom** : [NOM_DU_PROJET].
- **Architecture** : [monorepo / repo simple] à [NOMBRE] sous-projets :
  - `[CHEMIN_FRONTEND]/` : application [FRAMEWORK_FRONTEND] [VERSION] ([OPTIONS]).
  - `[CHEMIN_BACKEND]/` : [TYPE_API] [FRAMEWORK_BACKEND] [VERSION] ([OPTIONS]).
- **Langage** : [LANGAGE_PRINCIPAL] [VERSION].
- **Gestionnaire de paquets** : [npm / pnpm / yarn / poetry / ...] pour le frontend ;
  [npm / pnpm / yarn / poetry / ...] pour le backend.
- **API** : le frontend appelle `[URL_API]` ([proxy / direct]).
- **Port par défaut** : frontend `[PORT_FRONTEND]`, backend `[PORT_BACKEND]`.

## 2. Règles absolues (non négociables)

1. **Ne jamais supprimer de fichier** sans demande explicite de l'utilisateur.
2. **Toujours lint + test** après toute feature/patch/fix avant de considérer la tâche
   terminée. Voir `scripts/verify.sh`.
3. **Toujours commiter** avec la convention Conventional Commits (voir §6).
4. **Code clean** : lisible, typé, sans code mort, sans `console.log` oubliés.
5. **Ne pas inventer d'API.** Si une lib/un endpoint est incertain, vérifier la doc
   réelle (fichiers du repo, types, doc officielle) avant d'écrire le code.
6. **Secrets** : jamais en clair dans le code ou les commits. Utiliser `.env` (gitignored).

## 3. Workflow obligatoire : Plan → Execute → Verify

Tout changement non trivial (≥ 3 étapes ou touchant plusieurs fichiers) suit ce cycle.
Détail complet dans `docs/workflow-plan-execute-verify.md`.

1. **PLAN** — Avant de coder : lister les fichiers à toucher, l'approche, les risques,
   et comment ce sera vérifié. Attendre validation si l'impact est important.
   - Avec Claude : `/plan`.
   - Avec Copilot : snippet `!plan` ou demande « plan sans coder ».
2. **EXECUTE** — Implémenter par petits incréments cohérents. Un commit = un changement
   logique.
   - Avec Claude : `/implement`.
   - Avec Copilot : snippet `!implement`.
3. **VERIFY** — Lancer `scripts/verify.sh` (lint + test + build). Ne **jamais** se
   déclarer « terminé » si une étape échoue. Si bloqué, le dire explicitement.
   - Avec Claude : `/verify`.
   - Avec Copilot : snippet `!verify` ou exécution manuelle de `bash scripts/verify.sh`.

Cette boucle est ce qui distingue un agent fiable d'une démo : la phase Verify est un
**gate déterministe**, pas une auto-évaluation de l'agent.

## 3bis. Commandes et snippets disponibles

| Agent | Mécanisme | Plan | Execute | Verify | Definition of Done | Commit | Init |
|---|---|---|---|---|---|---|---|
| Claude Code | slash commands (`.claude/commands/*.md`) | `/plan` | `/implement` | `/verify` | non applicable | manuel ou guidé par `/verify` | `/init-project` |
| GitHub Copilot | VS Code snippets (`.vscode/harness.code-snippets`) | `!plan` | `!implement` | `!verify` | `!dod` | `!commit` | `!init` |

Les snippets permettent de coller les prompts du harness dans Copilot Chat ou l'éditeur,
exactement comme les slash commands le font pour Claude.

La commande `/init-project` (Claude) et le snippet `!init` (Copilot) initialisent ou
réalignent le harness avec la stack réelle du repo : détection de la stack, librairies de
composants, scripts, structure, et mise à jour des fichiers de documentation.

## 4. Conventions de code

Référence détaillée : `docs/conventions-[STACK].md`. En résumé :

**Frontend ([FRAMEWORK_FRONTEND] / HTML / [CSS])**
- En plus des conventions générales, tout fichier HTML, [CSS] ou template est soumis aux
  règles de :
  - `docs/rules-html-accessibility.md` (a11y)
  - `docs/rules-frontend-design.md` (design system, tokens, responsive)
  - `docs/rules-component-libraries.md` (librairies de composants détectées par `/init-project`)
- Si une librairie de composants est listée dans `docs/rules-component-libraries.md`,
  utiliser ses composants en priorité plutôt que d'en créer un équivalent maison.
- [RÈGLES_FRONTEND_1].
- [RÈGLES_FRONTEND_2].
- Pas de logique dans les templates au-delà du binding simple.

**Commun ([LANGAGE])**
- Typage strict activé. Pas de type implicite large.
- Nommage : `camelCase` (variables/fonctions), `PascalCase` (classes/types/composants),
  `UPPER_SNAKE_CASE` (constantes globales).
- Fonctions courtes, une responsabilité. Pas de fonction > ~50 lignes sans raison.
- Gestion d'erreur explicite : pas de `catch` vide, pas d'erreur avalée.

**Backend ([FRAMEWORK_BACKEND])**
- Architecture en couches : [RÈGLES_ARCHITECTURE_BACKEND].
- Validation des entrées à la frontière avant la logique.
- Erreurs centralisées. Codes HTTP corrects.
- Pas de logique métier dans les routes/contrôleurs.

## 5. Structure attendue

```
[CHEMIN_FRONTEND]/        → [FRAMEWORK_FRONTEND]
  src/
    core/                 → services singleton, intercepteurs, guards
    shared/               → composants/pipes/directives réutilisables
    features/<feature>/   → un dossier par fonctionnalité
      [EXTS]

[CHEMIN_BACKEND]/         → [FRAMEWORK_BACKEND]
  src/
    [POINT_ENTRÉE]
    [DOSSIERS_PAR_DOMAINE]
```

⚙️ REMPLIR : adapter l'arborescence à la structure réelle.

## 6. Commits (Conventional Commits)

Format imposé :

```
<type>[scope optionnel]: <description courte à l'impératif>

[corps optionnel : pourquoi, pas comment]

[footer optionnel : BREAKING CHANGE, refs tickets]
```

Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `style`, `ci`,
`build`. Description en minuscule, sans point final, ≤ 72 caractères.

Exemples :
- `feat([SCOPE]): ajoute [DESCRIPTION]`
- `fix([SCOPE]): corrige [DESCRIPTION]`

## 7. Definition of Done

Une tâche n'est terminée que si **toutes** ces cases sont cochées :

- [ ] Le code compile ([COMMANDE_BUILD] OK).
- [ ] Le lint passe sans erreur.
- [ ] Les tests passent ; un comportement nouveau a un test.
- [ ] Pas de fichier supprimé sans accord.
- [ ] Commit(s) au format Conventional Commits.
- [ ] Code clean : pas de `console.log`/`debugger`/code mort.
- [ ] Le gate `bash scripts/verify.sh` sort en code 0.
