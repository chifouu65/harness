# Harness — config partagée Copilot + Claude

Un *harness* léger et réutilisable : un ensemble de fichiers d'instructions qui donnent à
**GitHub Copilot** et **Claude** (Code / Cowork) le même cadre de travail sur tes projets
**Angular + NestJS (TypeScript)**.

L'idée du harness engineering : la qualité d'un agent vient surtout de ce qui l'entoure
(règles, workflow, vérification déterministe), pas seulement du modèle. Ce dossier en est
la version « config » : à déposer dans n'importe quel repo.

## Contenu

| Fichier | Rôle |
|---|---|
| `AGENTS.md` | **Source de vérité unique.** Toutes les règles vivent ici. |
| `CLAUDE.md` | Pointe vers `AGENTS.md` + spécifique Claude. Lu automatiquement par Claude. |
| `.github/copilot-instructions.md` | Pointe vers `AGENTS.md` + spécifique Copilot. Lu automatiquement par Copilot. |
| `.claude/commands/` | Commandes `/plan`, `/implement`, `/verify` pour Claude. |
| `.vscode/harness.code-snippets` | Snippets `!plan`, `!implement`, `!verify`, `!dod` pour VS Code / Copilot Chat. |
- `docs/workflow-plan-execute-verify.md` | Le workflow central, détaillé. |
- `docs/conventions-angular-express.md` | Conventions de code détaillées. |
- `docs/rules-html-accessibility.md` | Règles a11y pour tout HTML/template Angular. |
- `docs/rules-frontend-design.md` | Règles design/tokens/responsive pour le frontend. |
- `scripts/verify.sh` | Gate déterministe : lint + test + build. |

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
   scripts/verify.sh
   ```
2. Ouvre `AGENTS.md` et complète les sections marquées ⚙️ (nom du produit, archi,
   structure réelle des dossiers).
3. Adapte `scripts/verify.sh` aux noms de tes sous-projets et de tes scripts npm
   (`lint`, `test`, `build`).
4. Commite : `chore: ajoute le harness agents (config Copilot + Claude)`.

## Utilisation

- **Copilot** lit `.github/copilot-instructions.md` automatiquement (suggestions + Chat).
  Utilise les snippets `!plan`, `!implement`, `!verify`, `!dod` dans Copilot Chat ou
  l'éditeur pour appliquer le cycle.
- **Claude** lit `CLAUDE.md` automatiquement. Utilise les commandes `/plan`,
  `/implement`, `/verify` pour suivre le cycle.
- Les deux convergent vers `AGENTS.md` : **une seule règle à modifier** quand tu changes
  une convention.

## Le principe à retenir

Toute tâche non triviale suit **Plan → Execute → Verify**, et ne se termine que quand
`scripts/verify.sh` sort en code 0. C'est ce gate déterministe qui rend les agents
fiables plutôt qu'« impressionnants en démo ».
