# Telegram Send File Skill

Send files, images, documents, and audio back to user via Telegram Bot API.
Use this skill whenever you need to deliver a generated file (PNG chart, Excel, PDF, audio, etc.) to the user.

**RULE: Never just say "file saved at /path/". Always send it.**

---

## Get Bot Token & Chat ID

```bash
# Token is in openclaw config
TOKEN=$(cat ~/.openclaw/openclaw.json | python3 -c "
import json,sys
d=json.load(sys.stdin)
# Try common locations
for path in [
    ['channels','telegram','token'],
    ['channel','token'],
    ['telegram','token'],
]:
    try:
        v=d
        for k in path: v=v[k]
        print(v); break
    except: pass
")

# Get recent chat_id from Telegram updates
CHAT_ID=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates" | python3 -c "
import json,sys
d=json.load(sys.stdin)
msgs=d.get('result',[])
if msgs:
    m=msgs[-1]['message']
    print(m['chat']['id'])
")
```

---

## Send Image / Photo

```bash
curl -F "photo=@/path/to/image.png" \
     -F "caption=Your caption here" \
     "https://api.telegram.org/bot${TOKEN}/sendPhoto?chat_id=${CHAT_ID}"
```

## Send Document / File (Excel, PDF, any file)

```bash
curl -F "document=@/path/to/file.xlsx" \
     -F "caption=File description" \
     "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=${CHAT_ID}"
```

## Send Audio

```bash
curl -F "audio=@/path/to/audio.mp3" \
     "https://api.telegram.org/bot${TOKEN}/sendAudio?chat_id=${CHAT_ID}"
```

## Send Text Message

```bash
curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
     -d "chat_id=${CHAT_ID}" \
     -d "text=Your message here" \
     -d "parse_mode=Markdown"
```

---

## Full Workflow Example (generate chart → send)

```bash
# 1. Get credentials
TOKEN=$(cat ~/.openclaw/openclaw.json | python3 -c "
import json,sys
d=json.load(sys.stdin)
for path in [['channels','telegram','token'],['channel','token'],['telegram','token']]:
    try:
        v=d
        for k in path: v=v[k]
        print(v); break
    except: pass
")
CHAT_ID=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates" | python3 -c "
import json,sys
d=json.load(sys.stdin)
msgs=d.get('result',[])
if msgs: print(msgs[-1]['message']['chat']['id'])
")

# 2. Generate chart (example)
python3 << 'EOF'
import matplotlib.pyplot as plt
data = {'Jan': 100, 'Feb': 150, 'Mar': 200}
plt.figure(figsize=(8,5))
plt.bar(data.keys(), data.values(), color='#2196F3')
plt.title('Monthly Data')
plt.tight_layout()
plt.savefig('/root/.openclaw/workspace/output.png', dpi=150)
print("Chart saved")
EOF

# 3. Send to Telegram
curl -F "photo=@/root/.openclaw/workspace/output.png" \
     -F "caption=📊 Chart generated" \
     "https://api.telegram.org/bot${TOKEN}/sendPhoto?chat_id=${CHAT_ID}"
```

---

## Notes

- Files must be accessible inside proot Ubuntu (not on /sdcard)
- Max file size: 50MB for documents, 10MB for photos
- If photo upload fails, fallback to sendDocument (no size compression)
- Always use absolute paths
- Output directory: `~/.openclaw/workspace/`

---

## Fallback: Base64 in message (if curl fails)

```bash
base64 /path/to/image.png | curl -s -X POST \
  "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=\`\`\`$(base64 /path/to/small_file.txt)\`\`\`" \
  -d "parse_mode=Markdown"
```
