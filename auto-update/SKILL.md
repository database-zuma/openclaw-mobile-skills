# Auto-Update Skill

Keep skills, AGENTS.md, and knowledge base up-to-date automatically via cron.
Sends Telegram notification after every update (success or fail).

---

## Setup Auto-Update (run once)

```bash
mkdir -p ~/.openclaw/logs

# Create update script
cat > ~/.openclaw/update.sh << 'SCRIPT'
#!/bin/bash
LOG="$HOME/.openclaw/logs/update.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

# Get Telegram credentials
TOKEN=$(python3 -c "
import json
d=json.load(open('$HOME/.openclaw/openclaw.json'))
for path in [['channels','telegram','token'],['channel','token'],['telegram','token']]:
    try:
        v=d
        for k in path: v=v[k]
        print(v); break
    except: pass
" 2>/dev/null)

CHAT_ID=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates" | python3 -c "
import json,sys
d=json.load(sys.stdin)
msgs=d.get('result',[])
if msgs: print(msgs[-1]['message']['chat']['id'])
" 2>/dev/null)

send_tg() {
  curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d "chat_id=${CHAT_ID}" \
    -d "text=$1" \
    -d "parse_mode=Markdown" > /dev/null
}

# Run update
echo "[$TIMESTAMP] Starting update..." >> "$LOG"
cd ~/.claude/skills

BEFORE=$(git rev-parse HEAD 2>/dev/null)
git pull -q >> "$LOG" 2>&1
PULL_STATUS=$?
AFTER=$(git rev-parse HEAD 2>/dev/null)

if [ $PULL_STATUS -ne 0 ]; then
  echo "[$TIMESTAMP] git pull FAILED" >> "$LOG"
  send_tg "⚠️ *Auto-update FAILED* ($TIMESTAMP)%0Agit pull error — cek log: \`~/.openclaw/logs/update.log\`"
  exit 1
fi

if [ "$BEFORE" = "$AFTER" ]; then
  echo "[$TIMESTAMP] No changes" >> "$LOG"
  # Silent — no Telegram if nothing changed
  exit 0
fi

# There were changes — run setup
SETUP_OUT=$(bash setup.sh 2>&1)
SETUP_STATUS=$?
echo "$SETUP_OUT" >> "$LOG"

CHANGED=$(git log --oneline "$BEFORE".."$AFTER" 2>/dev/null | head -5)

if [ $SETUP_STATUS -eq 0 ]; then
  send_tg "✅ *Auto-update berhasil* ($TIMESTAMP)%0A%0AChanges:%0A\`\`\`%0A${CHANGED}%0A\`\`\`"
else
  send_tg "⚠️ *Auto-update: pull OK tapi setup gagal* ($TIMESTAMP)%0Acek log: \`~/.openclaw/logs/update.log\`"
fi

echo "[$TIMESTAMP] Done" >> "$LOG"
SCRIPT

chmod +x ~/.openclaw/update.sh

# Register cron
(crontab -l 2>/dev/null; echo "0 3 * * * bash ~/.openclaw/update.sh") | crontab -

echo "✅ Auto-update cron set — laporan dikirim ke Telegram tiap ada perubahan"
crontab -l
```

---

## Behavior

| Kondisi | Telegram |
|---------|----------|
| Tidak ada update | Silent (tidak kirim) |
| Update berhasil | ✅ Notif + daftar perubahan |
| git pull gagal | ⚠️ Error notif |
| setup.sh gagal | ⚠️ Error notif |

---

## Commands

```bash
# Cek cron aktif
crontab -l

# Test manual (jalankan update sekarang)
bash ~/.openclaw/update.sh

# Lihat log
tail -30 ~/.openclaw/logs/update.log

# Hapus auto-update
crontab -l | grep -v "update.sh" | crontab -
```
