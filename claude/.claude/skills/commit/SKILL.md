---
name: commit
description: Commit staged/unstaged work following the team git workflow (conventional type(scope) summary + GitLab issue #id). Use when the user says "commit", "/commit", or asks to create a commit, branch, or MR title per the team guidelines.
---

# Commit

Format: `<type>(<scope>): <summary> #<issue-id>`

- Summary ≤72 chars, imperative ("add", not "added"), no trailing period.
- GitLab issue ref (`#124`) required at end. If unknown, take it from the branch name (`feature/124-...`); if still unknown, ask.
- Body only when the *why* isn't obvious: blank line, then explain why, not what.
- Types: feat, fix, refactor, perf, test, docs, chore, style, ci.

```
feat(auth): add JWT refresh token rotation #124
fix(checkout): prevent double charge on retry #87
```

## Steps

1. `git status && git diff --staged` (also `git diff` if nothing staged) and `git log -5 --oneline`.
2. If nothing staged, stage the relevant files — never `git add -A` blindly, never `.env`.
3. Derive scope from the touched area, id from the branch. Commit.
4. Verify with `git status`.
5. Check the subject line is ≤72 chars: `git log -1 --format="%s" | wc -c` (subtract 1 for the newline). If over, `git commit --amend -m "..."` to reword.
6. Report every commit made this run: hash, final message, and message char length (the `wc -c` count minus 1).

## Rules

- Never add `Co-Authored-By: Claude` or `Claude-Session:` trailers — commit messages carry no Claude attribution, in commits or MR bodies.
- Never commit to `main`/`develop` — branch first: `<type>/<issue-id>-<short-desc>`.
- Keep 1–3 commits per branch. More than 3 → `git rebase -i HEAD~N` and squash before MR.
- Update branch with `git fetch origin && git rebase origin/main`. Never `git merge main` into a feature branch.
- Push with `--force-with-lease` after a rebase. Never force-push main/develop.
- Merge only via MR (squash, or rebase for 2–3 meaningful commits).

MR title uses the same commit format; body = `## What` / `## Why` (with issue ref) / `## Testing` checklist.
