# Rule: Git Commit Checklist — Pre-Commit Gate for New & Modified Files

## Purpose
Before any new or modified file enters the Git repository, a mandatory pre-commit gate must be passed. This applies to files created by **human developers** and **AI agents** alike. The goal is a clean, traceable, auditable repository (IEC 62304 §8, ISO 13485 §4.2.4).

## When This Rule Applies
- **After any file creation or modification** by any agent or human
- **Before `git add` or `git commit`**
- **At minimum once per working session** (morning check-in, evening check-out)

---

## 1. Pre-Commit File Scan

### 1.1 Identify All Changed Files

```bash
git status --short
```

Categorize each file:

| Status | Meaning | Action |
|--------|---------|--------|
| `M` (modified) | Existing tracked file changed | Proceed to §2 (modified file check) |
| `A` (added) | New file staged | Proceed to §3 (new file check) |
| `??` (untracked) | New file not yet staged | Decide: commit or ignore? (§3) |
| `D` (deleted) | File removed | Verify intentional, update references (§2.3) |

### 1.2 Morning Routine
At the start of every working session:
```bash
git status --short    # What changed since last session?
git diff --stat       # How big are the changes?
```
This prevents leftover artifacts from a previous agent run or manual edit from being forgotten.

---

## 2. Modified File Checklist

For every **modified** (`M`) file, verify:

- [ ] **Change is intentional** — not a side effect of a script or agent auto-formatting
- [ ] **Change belongs in this commit** — not mixing unrelated changes (one commit = one logical change)
- [ ] **No commented-out code added** — IEC 62304 finding risk (use git history, not dead code)
- [ ] **No debugging artifacts left** — `std::cout`, `printf`, `console.log`, temporary log dumps
- [ ] **No hardcoded paths/secrets/tokens** — no `/home/user/`, no passwords, no API keys
- [ ] **No generated files modified by hand** — if a file is auto-generated (e.g., dashboard data, traceability), don't hand-edit it; fix the generator
- [ ] **Trailing whitespace cleaned** — no trailing spaces or tabs on empty lines
- [ ] **File ends with exactly one newline** — POSIX standard, avoids diff noise

### 2.1 For Agent-Generated Modifications

- [ ] Agent modified only files it owns per its listening pattern (`.pi/agents/<agent>.md`)
- [ ] Agent did not overwrite human-authored content
- [ ] Agent's changes are consistent with the architecture/specification it observed

### 2.2 For Merge/Conflict Resolution

- [ ] No conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) left in files
- [ ] Both sides of the merge are functional — build and tests pass

### 2.3 For Deleted Files

- [ ] Deletion is intentional and documented (commit message explains why)
- [ ] No remaining references to the deleted file (broken includes, broken links in docs)
- [ ] File moved to `project/99_Archive/` if it's a superseded document (V-Model traceability)

---

## 3. New File Checklist (Untracked `??` or Staged `A`)

**This is the critical gate.** Every new file must earn its place in the repository.

### 3.1 Should This File Be Committed?

| File Type | Commit? | Condition |
|-----------|---------|-----------|
| **Source code** (`.hpp`, `.cpp`, `.c`, `.h`) | ✅ YES | Must trace to an architectural element |
| **Test code** (`test_*.cpp`) | ✅ YES | Must accompany its module |
| **Build configuration** (`CMakeLists.txt`, `Makefile`) | ✅ YES | Required for reproducibility |
| **Project documentation** (`project/**/*.md`) | ✅ YES | Part of the technical file |
| **Agent configuration** (`.pi/agents/*.md`) | ✅ YES | Defines agent behavior |
| **Rules** (`.pi/rules/*.md`) | ✅ YES | Binding project standards |
| **Skills** (`.pi/skills/*.md`) | ✅ YES | Agent methodology |
| **Scripts** (`.pi/scripts/*`) | ✅ YES | Automation tooling |
| **Dashboard source** (`dashboard/*.html`, `*.js`, `*.css`) | ✅ YES | Project dashboard |
| **Dashboard data** (`dashboard/data/*.json`) | ❌ NO | Runtime-generated, in `.gitignore` |
| **Build artifacts** (`build/`, `*.o`, `*.so`) | ❌ NO | In `.gitignore` |
| **IDE files** (`.vscode/`, `.idea/`) | ❌ NO | In `.gitignore` |
| **Temporary files** (`*.tmp`, `*.bak`, `*~`) | ❌ NO | In `.gitignore` |
| **Secrets** (`.env`, `*.pem`, `*.key`) | ❌ NO | In `.gitignore` — NEVER commit |
| **Large binaries** (images, PDFs, database files) | ⚠️ ASK | >1MB: use Git LFS or external storage |

### 3.2 Content Quality Gate (New Files Only)

- [ ] **File has a clear purpose** — stated in first 5 lines (comment header or markdown title)
- [ ] **File is in the correct directory** — matches project structure from `PI_CONTEXT.md`
- [ ] **File follows naming conventions** — `.pi/rules/document-naming.md` for docs, `.pi/rules/coding-standards.md` §3 for code
- [ ] **No duplicated content** — not a copy of another file with minor changes
- [ ] **No empty files** — every committed file has meaningful content
- [ ] **File is referenced** — if it's a new document, it's listed in `project/10_Documentation/DocumentIndex.md` (or will be)
- [ ] **No absolute paths** — all file references are relative to repository root
- [ ] **Appropriate line endings** — LF for `.sh`, `.py`, `.md`, `.cpp`, `.hpp`; CRLF only if Windows-native tooling requires it

### 3.3 Agent-Generated File Specific Checks

When an agent creates a new file:

- [ ] **Created by the correct agent** — file is in the agent's "Produces" directory per its listening pattern
- [ ] **Agent observed its input layer** — file content is based on what the agent observed, not hallucinated
- [ ] **No placeholder content** — no `TODO`, `FIXME`, `{PROJECT_NAME}`, `{SAFETY_CLASS}` left unfilled
- [ ] **Cross-references are valid** — links to other project files actually resolve
- [ ] **Status updated** — `dashboard/data/status.json` reflects the new artifact (if applicable)

---

## 4. Commit Message Standards

### 4.1 Format

```
<type>: <short description>
        ↑
        Must be one of: feat, fix, docs, refactor, test, chore, style, rule, skill
```

### 4.2 Examples

```
feat: add protocol engine with state machine and observer pattern
fix: resolve bus timeout on motor stall recovery
docs: update SW-SAD with data model for result calculation
refactor: extract assay protocol parser to separate module
test: add unit tests for motor controller edge cases
chore: update cmake minimum version to 3.16
style: apply coding standards to workflow module
rule: add coding-standards.md derived from software architecture
skill: add pre-commit checklist for new files
```

### 4.3 Multi-Line Messages (for complex changes)

```
feat: implement LIS communication layer

- Add ASTM E1394 / HL7 message parser
- Add LIS connection manager with reconnection logic
- Add result upload queue with retry

Refs: REQ-042, REQ-043
SW-SAD: §4.2 Communication Layer
```

### 4.4 What NOT to Put in Commit Messages

- ❌ `WIP`, `tmp`, `test`, `asdf` — no descriptive value
- ❌ `fixed stuff` — what stuff?
- ❌ `updated file` — which file, why?
- ❌ JIRA ticket number alone — include what was done

---

## 5. Before-You-Push Final Gate

Before `git push`, run these checks:

```bash
# 1. No large files accidentally staged (>1MB)
git diff --cached --stat | awk '{if($1 ~ /^...\|/) print $0}' 

# 2. Review what will be pushed
git log --oneline origin/main..HEAD

# 3. Build check (if code changed)
make build 2>&1 | tail -20

# 4. Quick content scan for secrets
git diff --cached | grep -iE '(password|secret|token|api.key|-----BEGIN)' && echo "⚠️ SECRETS DETECTED" || echo "✅ No secrets"
```

---

## 6. Quick Reference: Session Start & End

### Morning / Session Start
```bash
git status --short
git diff --stat
# → Are there uncommitted changes from last session? If yes, commit them first.
```

### Evening / Session End
```bash
git status --short
# → Any modified files not yet committed? Commit them or document why not.
git add -A
git status --short    # Review what will be committed
git diff --cached --stat
# → Run through §2 and §3 checklists
git commit -m "<type>: <description>"
```

### Rule of Thumb
> **Never end a session with uncommitted changes.** If a change isn't worth committing, it isn't worth keeping. Stash or discard.

---

## 7. Agent-Specific: Auto-Commit Protocol

When an AI agent creates or modifies files:

1. Agent completes its task → files are written
2. Agent runs `git status --short` to see what changed
3. Agent applies §2 (modified) and §3 (new) checklists
4. If all checks pass → agent stages and commits with appropriate message
5. If checks fail → agent reports issues to user, does NOT commit
6. Agent updates `dashboard/data/status.json` if the change affects project state

**Agent commit messages must include the agent role:**
```
rule: add git-commit-checklist (by developer agent)
feat: implement motor controller module (by developer agent)
docs: update FMEA with new hazard analysis (by risk-manager agent)
```
