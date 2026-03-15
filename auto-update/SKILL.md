# Auto-Update Skill

Keep skills, AGENTS.md, and knowledge base up-to-date automatically via cron.
Use this skill to set up or manage the auto-update schedule.

---

## Setup Auto-Update (run once)

```bash
mkdir -p ~/.openclaw/logs

# Add cron job: update every day at 03:00
(crontab -l 2>/dev/null; echo "0 3 * * * cd ~/.claude/skills && git pull -q && bash setup.sh >> ~/.openclaw/logs/update.log 2>&1") | crontab -

echo "✅ Auto-update cron set for 03:00 daily"
crontab -l
```

## Check Status

```bash
# View cron jobs
crontab -l

# View last update log
tail -30 ~/.openclaw/logs/update.log

# Check when last update ran
ls -la ~/.openclaw/logs/update.log
```

## Manual Update (anytime)

```bash
cd ~/.claude/skills && git pull && bash setup.sh
```

## Remove Auto-Update

```bash
crontab -l | grep -v "openclaw-mobile-skills" | crontab -
echo "✅ Auto-update removed"
```

## Change Schedule

```bash
# Remove old job
crontab -l | grep -v "openclaw-mobile-skills" | crontab -

# Add with new schedule (example: every 6 hours)
(crontab -l 2>/dev/null; echo "0 */6 * * * cd ~/.claude/skills && git pull -q && bash setup.sh >> ~/.openclaw/logs/update.log 2>&1") | crontab -
```

## Notes

- Cron runs inside proot Ubuntu, not Termux native
- MEMORY.md is never overwritten by updates (your memory is safe)
- Logs saved to `~/.openclaw/logs/update.log`
- `git pull -q` = silent pull, only logs if there are changes
