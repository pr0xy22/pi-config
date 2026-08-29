# Learner files

All session state lives in the **learner's working directory**, not in this skill repo.

```
.alvar/
  LEARNER.md                 # how this mind wants to be taught
  maps/<slug>.md             # probe results for one goal
  sessions/<date>-<slug>.md  # plan + steps + quizzes
  visuals/<slug>-<n>.svg     # diagrams from learn-visual
```

Create `.alvar/` on first use.

## LEARNER.md

If missing, run `learn-profile` or write a stub from `assets/LEARNER.md` and ask 3–5 questions to fill it. Do not invent a personality.

Read LEARNER.md at the start of every `teach` session. It controls:

- voice and density
- how they want struggle
- what they already treat as solid
- whether they want visuals, mermaid, LaTeX, or a long markdown log

## Map file

```markdown
# Map — <goal>

Updated: <ISO date>
Goal: <one sentence>

## Strands
| strand | status | evidence |
|--------|--------|----------|
| line integrals | known | Q2 correct, explained work |
| Stokes | edge | recognized statement, missed Faraday link |
| differential forms | unknown | said so |
| SR field mix | blocked | answered "I don't know" |

Status: `known` | `edge` | `unknown` | `blocked`

## Quiz log
- Q1 [line integrals] C — correct
```

## Session file

```markdown
# Session — <goal>
Date:
Model:
Goal:

## Plan
\`\`\`mermaid
graph TD
  A[covector] --> B[1-form]
  B --> C[wedge]
\`\`\`

## Log
### Node: covector
- taught:
- visual:
- quiz:
- result: lock-in | retry | insert-prereq
```

These files are the persistence layer (the portable stand-in for a markdown-log / Obsidian pane). Keep them updated as you go.

**Claude Code only** (the harness has the `AskUserQuestion` tool — see the detection table in [quiz-ui.md](quiz-ui.md)): batch the actual file writes at natural stopping points — end of session, or a long pause — instead of after every single quiz or node. Track what's happening in them mentally in the meantime so nothing is lost. This works around latency in one specific learner's external log/viewer setup; other harnesses (Grok, Codex, OpenCode, Pi) should keep writing these files as they go.
