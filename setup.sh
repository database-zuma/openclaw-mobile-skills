#!/bin/bash
# OpenClaw Mobile Setup
# Run after git pull to deploy everything to the right places
# Usage: bash setup.sh

set -e

SKILLS_DIR="$HOME/.claude/skills"
WORKSPACE="$HOME/.openclaw/workspace"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🦞 OpenClaw Mobile Setup"
echo "========================"

# 1. Skills
echo "📦 Deploying skills..."
mkdir -p "$SKILLS_DIR"
if [ "$REPO_DIR" = "$SKILLS_DIR" ]; then
  echo "  ⏭️  Repo is skills dir — skipping copy (already in place)"
  for skill_dir in "$REPO_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    [[ "$skill_name" == "workspace" ]] && continue
    [[ "$skill_name" == "knowledge" ]] && continue
    [[ ! -f "$skill_dir/SKILL.md" ]] && continue
    echo "  ✅ $skill_name"
  done
else
  for skill_dir in "$REPO_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    [[ "$skill_name" == "workspace" ]] && continue
    [[ "$skill_name" == "knowledge" ]] && continue
    [[ ! -f "$skill_dir/SKILL.md" ]] && continue
    mkdir -p "$SKILLS_DIR/$skill_name"
    cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$skill_name/SKILL.md"
    echo "  ✅ $skill_name"
  done
fi

# 2. Workspace files (AGENTS.md, MEMORY.md)
echo "🧠 Deploying workspace..."
mkdir -p "$WORKSPACE"

# AGENTS.md — always overwrite (instructions update with repo)
cp "$REPO_DIR/workspace/AGENTS.md" "$WORKSPACE/AGENTS.md"
echo "  ✅ AGENTS.md"

# MEMORY.md — only create if doesn't exist (preserve existing memory)
if [ ! -f "$WORKSPACE/MEMORY.md" ]; then
  cp "$REPO_DIR/workspace/MEMORY.md" "$WORKSPACE/MEMORY.md"
  echo "  ✅ MEMORY.md (created fresh)"
else
  echo "  ⏭️  MEMORY.md (kept existing — memory preserved)"
fi

# 3. Memory directory
mkdir -p "$WORKSPACE/memory"
echo "  ✅ memory/ directory"

# 4. Knowledge base
echo "📚 Deploying knowledge base..."
mkdir -p "$WORKSPACE/knowledge"
if [ -d "$REPO_DIR/knowledge" ]; then
  cp -r "$REPO_DIR/knowledge/"* "$WORKSPACE/knowledge/"
  echo "  ✅ knowledge base ($(ls "$REPO_DIR/knowledge" | wc -l | tr -d ' ') items)"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Restart your gateway: ocstart"
