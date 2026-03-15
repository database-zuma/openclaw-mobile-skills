# Install Commands — OpenClaw Mobile Tools

Copy-paste these commands to set up all tools.

---

## STEP 1 — Termux Native (jalankan di Termux, BUKAN di dalam Ubuntu)

```bash
pkg update && pkg upgrade -y
pkg install termux-api git python3 nodejs-lts curl wget jq sqlite openssh -y
termux-setup-storage
termux-wake-lock
```

> Setelah `termux-setup-storage`, izinkan akses storage di popup Android.
> Install juga app **Termux:API** dari F-Droid (terpisah dari Termux).

---

## STEP 2 — Masuk Ubuntu

```bash
proot-distro login ubuntu
```

---

## STEP 3 — Di dalam Ubuntu: install tools

```bash
apt update && apt upgrade -y
apt install git curl wget jq ffmpeg pandoc tesseract-ocr python3-pip sqlite3 -y
```

---

## STEP 4 — Python packages

```bash
pip install markitdown pandas numpy matplotlib plotly seaborn openpyxl scipy yt-dlp
```

---

## STEP 5 — Clone skills repo

```bash
mkdir -p ~/.claude/skills
cd ~/.claude/skills
git clone https://github.com/database-zuma/openclaw-mobile-skills.git .
```

> Kalau sudah pernah clone, update dengan:
> ```bash
> cd ~/.claude/skills && git pull
> ```

---

## STEP 6 — Copy knowledge folder ke workspace

```bash
mkdir -p ~/.openclaw/workspace/knowledge
cp -r ~/.claude/skills/knowledge/* ~/.openclaw/workspace/knowledge/
```

---

## Done! Restart gateway

```bash
ocstart
```

---

## Quick Reference — termux-api commands

Jalankan dari **Termux native** (bukan Ubuntu):

| Command | Fungsi |
|---------|--------|
| `termux-camera-photo -c 0 foto.jpg` | Foto kamera belakang |
| `termux-camera-photo -c 1 selfie.jpg` | Foto kamera depan |
| `termux-location -r once` | GPS location |
| `termux-battery-status` | Status baterai |
| `termux-clipboard-get` | Baca clipboard |
| `termux-clipboard-set "text"` | Set clipboard |
| `termux-notification --title "x" --content "y"` | Push notifikasi |
| `termux-sms-send -n +62xxx "pesan"` | Kirim SMS |
| `termux-sms-list -l 10` | Baca SMS masuk |
| `termux-tts-speak "text"` | Text to speech |
| `termux-torch on/off` | Senter |
| `termux-vibrate -d 500` | Getar 500ms |
| `termux-contact-list` | Daftar kontak |
| `termux-wifi-connectioninfo` | Info WiFi |
| `termux-microphone-record -l 5000 -f audio.mp4` | Rekam audio 5 detik |
| `termux-open-url "https://..."` | Buka URL di browser |
| `termux-share file.pdf` | Share file |
