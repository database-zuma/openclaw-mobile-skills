# OpenClaw Mobile Skills Setup (Android Termux)

Portable skill bundle for personal OpenClaw agent running on Android phone. Based on Iris capabilities but completely standalone — no Zuma VPS connections.

## Overview

**Target Environment:** Android phone with Termux + OpenClaw + MiniMax M2.5 coding plan + Telegram integration

**Skills Included:**
- `markitdown` — Convert any file (PDF, Word, Excel, etc.) to Markdown  
- `xlsx-skill` — Create/edit Excel files with professional formatting
- `data-visualization` — Generate charts/graphs from data (matplotlib/plotly)
- `statistical-analysis` — Compute descriptive stats, trends, correlations
- `deploy-to-live` — Git + GitHub + Vercel deployment workflow
- `coding-reference-hub` — Programming reference and best practices  
- `communication-humanizer` — Remove AI-speak from all output
- `anti-hallucination` — Prevent data fabrication with source tagging
- `strategic-decisions` — Business decision framework (10/10/10 analysis)

## Prerequisites

1. **OpenClaw running on Termux** with:
   - Node.js >= 22.12.0
   - MiniMax M2.5 coding plan configured
   - Telegram bot integration working
   - Agent named dynamically (not hardcoded)

2. **Required system packages** (install in Termux):
```bash
pkg update && pkg install -y git nodejs-lts python3 
pip install pandas matplotlib plotly seaborn openpyxl
```

3. **Authentication Setup** (you'll need these):
   - GitHub Personal Access Token (for deploy-to-live)
   - Vercel CLI Token (for deploy-to-live)
   - Basic `~/.openclaw/workspace/.env` file

## Installation Steps

### Step 1: Download & Extract Skills

```bash
# Download bundle (replace URL with actual location)
cd ~
wget [YOUR_BUNDLE_URL]/openclaw-mobile-skills-bundle.tar.gz

# Extract to OpenClaw skills directory  
mkdir -p ~/.claude/skills
cd ~/.claude/skills
tar -xzf ~/openclaw-mobile-skills-bundle.tar.gz --strip-components=1

# Verify extraction
ls -la ~/.claude/skills/
# Should show: anti-hallucination, communication-humanizer, data-visualization, etc.
```

### Step 2: Configure Environment Variables

Create basic env file:

```bash
mkdir -p ~/.openclaw/workspace
cat > ~/.openclaw/workspace/.env << 'EOF'
# GitHub Token for deploy-to-live (get from https://github.com/settings/tokens)
# Required scopes: repo, workflow  
GITHUB_TOKEN=your_github_token_here

# Optional: Add other API keys as needed
# OPENAI_API_KEY=your_key
# ANTHROPIC_API_KEY=your_key
EOF

chmod 600 ~/.openclaw/workspace/.env
```

### Step 3: Update OpenClaw Configuration

Add skills to your `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "install": {
      "nodeManager": "npm"
    },
    "enabled": [
      "markitdown",
      "xlsx-skill", 
      "data-visualization",
      "statistical-analysis",
      "deploy-to-live",
      "coding-reference-hub",
      "communication-humanizer",
      "anti-hallucination", 
      "strategic-decisions"
    ]
  }
}
```

### Step 4: Install Python Dependencies

Some skills require Python packages:

```bash
# For data-visualization and statistical-analysis
pip install pandas matplotlib plotly seaborn numpy scipy

# For xlsx-skill
pip install openpyxl

# For markitdown (if not already installed)
pip install markitdown
```

### Step 5: Test Skills

Restart OpenClaw and test a few skills:

```bash
# Via Telegram to your bot:
"Create a simple chart from this data: sales: 100, 150, 200"

# Should invoke data-visualization skill and return a chart

"Convert this text to a spreadsheet"
# Should invoke xlsx-skill

"Help me decide: should I learn React or Vue?"  
# Should invoke strategic-decisions framework
```

## Skill Usage Guide

### markitdown
Convert files to Markdown for processing:
- Send PDFs, Word docs, Excel files, images
- Agent will auto-convert to readable text
- Works with YouTube URLs too

### xlsx-skill  
Create professional Excel files:
- "Create a budget spreadsheet"
- "Make a report from this data" 
- Auto-formats with formulas and styling

### data-visualization
Generate charts from data:
- "Plot this as a line chart"
- "Create a bar chart comparing X and Y"
- Outputs PNG (for mobile) or HTML (interactive)

### statistical-analysis
Advanced data analysis:
- "Calculate correlation between A and B"  
- "Show trend analysis for this data"
- "Find outliers in this dataset"

### deploy-to-live
Ship code to production:
- "Deploy this to GitHub and Vercel"
- Handles git init, commit, push, deployment
- **Requires setup:** GitHub token + Vercel token

### strategic-decisions
Business decision framework:
- "Should I quit my job to start a startup?"
- Uses 10-min/10-month/10-year analysis
- Regret matrix + pre-mortem analysis

### communication-humanizer
Removes AI-speak from all responses:
- Automatically applied to agent output
- Makes responses sound more human
- No explicit invocation needed

### anti-hallucination
Prevents data fabrication:
- Tags all data with sources
- Explicitly states when data unavailable
- Maintains factual accuracy

## Configuration Notes

### For deploy-to-live skill:
1. Get GitHub token: https://github.com/settings/tokens
   - Scopes: `repo`, `workflow`
   - Store in `~/.openclaw/workspace/.env`

2. Get Vercel token: https://vercel.com/account/tokens
   - Replace `YOUR_VERCEL_TOKEN` in skill file
   - Or set as environment variable

3. Update GitHub org:
   - Replace `YOUR_GITHUB_ORG` with your username/org
   - In skill file: `deploy-to-live/SKILL.md`

### For data-visualization skill:
- Color palette already cleaned (no Zuma branding)
- Professional colors: dark gray, green, light gray, red
- Works with both PNG and HTML output

### For all skills:
- No hardcoded names/personalities (dynamic setup)
- No VPS connections required
- Completely portable across devices

## Troubleshooting

### "Skill not found" errors:
- Check `ls ~/.claude/skills/` shows all extracted skills
- Verify `openclaw.json` has skills listed in `enabled` array
- Restart OpenClaw after config changes

### Python package errors:
- Run `pip install --upgrade pandas matplotlib plotly` 
- Check Python path: `which python3`
- Ensure Termux has storage permissions

### Deploy-to-live authentication fails:
- Test GitHub token: `curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user`
- Check `.env` file has correct token format
- Verify token scopes include `repo` and `workflow`

### Charts/Excel files not generating:
- Check Python dependencies installed
- Verify output directory writable: `~/.openclaw/workspace/`
- Check agent logs for specific errors

## File Locations

- **Skills:** `~/.claude/skills/[skill-name]/`
- **Config:** `~/.openclaw/openclaw.json`  
- **Environment:** `~/.openclaw/workspace/.env`
- **Output:** `~/.openclaw/workspace/` (charts, Excel files, etc.)
- **Logs:** `~/.openclaw/logs/`

## Next Steps

After setup:
1. Test each skill individually via Telegram
2. Try combined workflows (e.g., data analysis → visualization → Excel export)
3. Configure additional API keys as needed
4. Customize agent behavior in `openclaw.json`

---

**Bundle Created:** March 2026  
**Source:** Iris Mac Mini capabilities → Portable OpenClaw Mobile  
**Environment:** Android Termux + OpenClaw + MiniMax M2.5 + Telegram