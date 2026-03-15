# Termux Android Tools Skill

Access Android hardware and system features via Termux CLI tools.
Use this skill when the user asks to take a photo, get location, send SMS, record audio, read clipboard, send notifications, check battery, or any Android hardware interaction.

---

## Prerequisites

**Must have installed (Termux native, NOT inside proot Ubuntu):**
- `termux-api` package: `pkg install termux-api`
- **Termux:API** app from F-Droid (separate app, required!)

**All termux-* commands must run in Termux native, NOT inside proot.**
If currently inside Ubuntu proot, exit first: `exit`

---

## Camera

```bash
# Take a photo (saves to file)
termux-camera-photo -c 0 /sdcard/photo.jpg    # back camera
termux-camera-photo -c 1 /sdcard/selfie.jpg   # front camera

# List available cameras
termux-camera-info
```

## Location / GPS

```bash
# Get current GPS location (JSON output)
termux-location

# Get location once (faster)
termux-location -p gps -r once
```

Output: `{ "latitude": ..., "longitude": ..., "altitude": ..., "accuracy": ... }`

## SMS

```bash
# Send SMS
termux-sms-send -n +628123456789 "Your message here"

# Read received SMS (last 10)
termux-sms-list -l 10

# Read SMS from specific number
termux-sms-list -n +628123456789
```

## Clipboard

```bash
# Get clipboard content
termux-clipboard-get

# Set clipboard content
echo "text to copy" | termux-clipboard-set

# Or directly
termux-clipboard-set "text to copy"
```

## Notifications

```bash
# Send a notification
termux-notification --title "Title" --content "Message body"

# Notification with action
termux-notification --title "Reminder" --content "Check this" --id 1

# Remove a notification
termux-notification-remove 1
```

## Battery

```bash
# Get battery status (JSON)
termux-battery-status
```

Output: `{ "health": "GOOD", "percentage": 85, "plugged": "UNPLUGGED", "status": "DISCHARGING", "temperature": 28.5 }`

## WiFi

```bash
# Current WiFi connection info
termux-wifi-connectioninfo

# WiFi scan (nearby networks)
termux-wifi-scaninfo
```

## Audio / Microphone

```bash
# Record audio (5 seconds)
termux-microphone-record -l 5000 -f /sdcard/recording.mp4

# Stop recording manually
termux-microphone-record -q

# Play audio file
termux-media-player play /sdcard/audio.mp3

# Stop playback
termux-media-player stop
```

## Text to Speech

```bash
# Speak text out loud
termux-tts-speak "Hello, I am your assistant"

# List available voices
termux-tts-engines
```

## Torch / Flashlight

```bash
termux-torch on
termux-torch off
```

## Vibration

```bash
# Vibrate for 500ms
termux-vibrate -d 500

# Vibrate with pattern (ms on, ms off, ms on)
termux-vibrate -d 200
```

## Contacts

```bash
# List all contacts (JSON)
termux-contact-list

# Search contact by name
termux-contact-list | jq '.[] | select(.name | contains("John"))'
```

## Call Log

```bash
# Recent call log
termux-call-log -l 20
```

## Share / Open Files

```bash
# Share a file (opens Android share sheet)
termux-share /sdcard/file.pdf

# Open URL in browser
termux-open-url "https://example.com"

# Open file with default app
termux-open /sdcard/photo.jpg
```

## Device Info

```bash
# Sensor data (accelerometer, gyroscope, etc.)
termux-sensor -s "accelerometer" -n 1

# Fingerprint auth prompt
termux-fingerprint
```

---

## Important Notes

- **Always run termux-* commands from Termux native**, not inside proot Ubuntu
- If agent is running inside proot, it must `exit` first, run the command, then re-enter proot
- File paths: use `/sdcard/` for shared storage accessible by other apps
- Termux:API app must be running in background for these commands to work
- Some commands require Android permissions (grant when prompted)

---

## Common Workflows

### Take photo and describe it
```bash
termux-camera-photo -c 0 /sdcard/temp_photo.jpg
# Then pass /sdcard/temp_photo.jpg to vision model
```

### Location-aware response
```bash
termux-location -r once | jq '{lat: .latitude, lon: .longitude}'
```

### Remind user via notification
```bash
termux-notification --title "⏰ Reminder" --content "Meeting in 10 minutes" --id 99
```

### Check if charging
```bash
termux-battery-status | jq '.plugged'
```
