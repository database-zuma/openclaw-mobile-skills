# Memory System Skill

Manage long-term and daily memory across sessions.
Use this skill to read, write, and search memory files.

---

## File Locations

```
~/.openclaw/workspace/
├── MEMORY.md          ← long-term facts (always read on session start)
└── memory/
    ├── 2026-03-15.md  ← today's log
    └── 2026-03-14.md  ← yesterday's log
```

---

## Read Memory (Session Start)

```bash
# Read long-term memory
cat ~/.openclaw/workspace/MEMORY.md

# Read today's log
cat ~/.openclaw/workspace/memory/$(date +%Y-%m-%d).md 2>/dev/null || echo "No log today yet"

# Read yesterday's log
cat ~/.openclaw/workspace/memory/$(date -d "yesterday" +%Y-%m-%d).md 2>/dev/null || echo "No log yesterday"
```

---

## Write Long-term Memory

When user says "remember this" or you learn something important:

```bash
# Append a fact to MEMORY.md
cat >> ~/.openclaw/workspace/MEMORY.md << EOF

## [Category]
- [fact] — $(date +%Y-%m-%d)
EOF
```

Or edit directly:
```bash
nano ~/.openclaw/workspace/MEMORY.md
```

---

## Write Daily Log

At end of conversation or when something notable happens:

```bash
mkdir -p ~/.openclaw/workspace/memory
cat >> ~/.openclaw/workspace/memory/$(date +%Y-%m-%d).md << EOF
## $(date +%H:%M)
- [what happened / task done / topic discussed]
EOF
```

---

## Search Memory

```bash
# Search all memory
grep -r "keyword" ~/.openclaw/workspace/memory/ ~/.openclaw/workspace/MEMORY.md

# Search knowledge base
grep -r "keyword" ~/.openclaw/workspace/knowledge/

# Find recent entries
ls -lt ~/.openclaw/workspace/memory/ | head -5
```

---

## Memory Hygiene Rules

1. **Always read MEMORY.md at session start** — takes 2 seconds, prevents forgetting
2. **Write immediately** — if you think "I should remember this", write it NOW
3. **MEMORY.md = curated facts** — not everything, just what matters long-term
4. **Daily log = raw events** — more verbose, date-stamped
5. **Never rely on context window** — it gets compacted. Files don't.
