---
name: commit
description: Commit staged/unstaged work following the team git workflow (conventional type(scope) summary + GitLab issue #id). Also handles "#bump" for a version bump + release commit. Use when the user says "commit", "/commit", "#bump", or asks to create a commit, branch, or MR title per the team guidelines.
---

# Commit

Format: `<type>(<scope>): <summary> #<issue-id>`

- Summary ≤72 chars, imperative ("add", not "added"), no trailing period.
- GitLab issue ref (`#124`) required at end. If unknown, take it from the branch name (`feature/124-...`); if still unknown, ask.
- Body only when the _why_ isn't obvious: blank line, then explain why, not what.
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
- Update branch with `git fetch origin && git rebase origin/main`. Never `git merge main` into a feature branch.
- Push with `--force-with-lease` after a rebase. Never force-push main/develop.
- Merge only via MR (squash, or rebase for 2–3 meaningful commits).

## `#bump`

Triggered by `#bump` (or `/commit #bump`). Version release flow:

1. Find the version: `package.json`, `pyproject.toml`, `Cargo.toml`, `VERSION`, or `git describe --tags --abbrev=0`. Read the current value.
2. Decide the bump from the commits since the last tag (`git log <last-tag>..HEAD --oneline`): breaking change → major, any `feat` → minor, otherwise patch.
3. **Ask the user to confirm** the proposed version before writing anything. Show current → proposed and the one-line reason. Wait for the answer.
4. Write the new version to the file(s), then commit: `chore(release): bump version to <x.y.z> #<issue-id>`.
5. Print a squash commit message for the branch — message only, nothing else:
   - Title in the standard format above.
   - Blank line, then a plain-prose description of the branch's changes (no bullets, no trailers).
