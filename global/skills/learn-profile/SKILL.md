---
name: learn-profile
description: >
  Interview the learner and write .alvar/LEARNER.md so the teacher can fit
  this one mind — pace, voice, solid ground, and how they want to struggle.
  Use when the user runs /learn-profile or /skill:learn-profile, or says
  how I learn, teaching style, set up tutoring, or install my learning
  preferences.
---

# Learn profile

Install **how this mind wants to be taught**. The file is the teacher. Self-contained — no external references.

## Interview (one cluster at a time)

Ask 1–2 questions per turn using `ask_user_question` (these are preference questions — no right answers). Never dump all clusters in one message.

1. **Solid ground** — what they already hold thoroughly (subjects, notations). This is what the teacher builds analogies from.
2. **Goal** — what "done" looks like for the next stretch. Interrogate until concrete (an exam, a score, a project — not "understand X").
3. **Pace** — default is one reasoning step, then a quiz-check. Only change if they insist.
4. **Struggle** — they keep the hard thinking; you keep logistics. Ask what kind of problems they want (exam-style, conceptual, mixed).
5. **Voice** — density, tone, explanation register (e.g. "explain like I'm 15"), hated LLM habits.
6. **Artifacts** — where session notes go, what they read markdown in (Obsidian etc.).

Use their own words in the file wherever possible. Do not invent a persona.

## Write

Create `.alvar/LEARNER.md` with these sections:

```markdown
# Learner

## How I learn
- Pace: ...
- Struggle: ...
- Explanations I want: ...
- Explanations I do not want: ...

## Voice
- Density: ...
- Tone: ...
- Notation I already use: ...

## Solid ground
- Topics I hold thoroughly: ...
- Watch out: ... (known traps/misconceptions, with the remedy)

## Goals
- Current: ...

## Artifacts
- Session notes go in: ...
- I read session markdown in: ...
```

If `.alvar/LEARNER.md` already exists, show a diff of proposed edits and wait for approval before writing.

## After

Show the file. Tell them the `teach` skill reads it every session. Offer to start on the current goal.
