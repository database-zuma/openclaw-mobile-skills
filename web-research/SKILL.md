# Web Research Skill

Research any topic from the web before generating content or answering questions.
Use this skill when the user asks you to research, find info, scrape a URL, or create content that requires up-to-date data.

**RULE: Never fabricate facts. Research first, then generate.**

---

## Quick Search (DuckDuckGo — no API key needed)

```bash
# Search and get top results
python3 << 'EOF'
import urllib.request, urllib.parse, json, re

query = "YOUR SEARCH QUERY HERE"
url = f"https://api.duckduckgo.com/?q={urllib.parse.quote(query)}&format=json&no_html=1"
req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
data = json.loads(urllib.request.urlopen(req).read())

# Abstract (direct answer)
if data.get("Abstract"):
    print("ANSWER:", data["Abstract"])
    print("SOURCE:", data["AbstractURL"])

# Related topics
print("\nRELATED:")
for t in data.get("RelatedTopics", [])[:5]:
    if isinstance(t, dict) and t.get("Text"):
        print("-", t["Text"][:150])
EOF
```

## Fetch & Read a URL

```bash
# Fetch article content and convert to clean markdown
python3 << 'EOF'
import urllib.request, subprocess, sys

url = "https://example.com/article"

# Fetch HTML
req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
html = urllib.request.urlopen(req, timeout=15).read().decode("utf-8", errors="ignore")

# Save to temp file
with open("/tmp/fetched.html", "w") as f:
    f.write(html)

# Convert to markdown using markitdown
result = subprocess.run(
    ["markitdown", "/tmp/fetched.html"],
    capture_output=True, text=True
)
print(result.stdout[:3000])  # First 3000 chars
EOF
```

## Scrapling (advanced — handles anti-bot sites)

```bash
# Install once
pip install scrapling --break-system-packages

# Use
python3 << 'EOF'
from scrapling import Fetcher

fetcher = Fetcher(auto_match=False)
page = fetcher.get("https://example.com", stealthy_headers=True)
print(page.get_all_text()[:3000])
EOF
```

## Search + Summarize Workflow

```python
# Full research pipeline: search → fetch top result → summarize
import urllib.request, urllib.parse, json, subprocess

def research(topic):
    # 1. Search
    url = f"https://api.duckduckgo.com/?q={urllib.parse.quote(topic)}&format=json&no_html=1"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    data = json.loads(urllib.request.urlopen(req).read())
    
    results = []
    
    # Direct answer
    if data.get("Abstract"):
        results.append(f"SUMMARY: {data['Abstract']}")
        results.append(f"SOURCE: {data['AbstractURL']}")
    
    # Related
    for t in data.get("RelatedTopics", [])[:3]:
        if isinstance(t, dict) and t.get("Text"):
            results.append(f"- {t['Text'][:200]}")
    
    return "\n".join(results)

print(research("YOUR TOPIC"))
```

## YouTube Research

```bash
# Get transcript/info from YouTube video
yt-dlp --write-auto-sub --skip-download --sub-format vtt -o "/tmp/%(title)s" "YOUTUBE_URL"

# Or just get video info
yt-dlp --dump-json "YOUTUBE_URL" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print('Title:', d['title'])
print('Description:', d['description'][:500])
print('Duration:', d['duration_string'])
"
```

## Workflow: Research → Generate → Send

Example: User asks "buatin artikel 3 tips produktivitas, riset dulu"

```bash
# 1. Research
python3 -c "
import urllib.request, urllib.parse, json
query = '3 tips produktivitas kerja terbukti'
url = f'https://api.duckduckgo.com/?q={urllib.parse.quote(query)}&format=json&no_html=1'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
data = json.loads(urllib.request.urlopen(req).read())
if data.get('Abstract'): print(data['Abstract'])
for t in data.get('RelatedTopics',[])[:5]:
    if isinstance(t,dict) and t.get('Text'): print('-', t['Text'][:200])
"

# 2. Generate markdown content based on research
cat > /tmp/artikel.md << 'EOF'
# 3 Tips Produktivitas Terbukti

[agent writes content based on research here]
EOF

# 3. Convert to PDF
pandoc /tmp/artikel.md -o /root/.openclaw/workspace/artikel.pdf

# 4. Send to Telegram (use telegram-send-file skill)
```

## Notes

- DuckDuckGo: free, no API key, good for general search
- scrapling: best for scraping specific URLs (handles Cloudflare etc)
- markitdown: best for converting HTML/PDF to clean readable text
- Always cite sources in your output
- Max fetch timeout: 15 seconds
