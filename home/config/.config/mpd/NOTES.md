Nice choice 😄 MPD + Hyprland is a clean, powerful combo.

Below is a **full-featured `mpd.conf`** tailored for **local music**, modern desktops (PipeWire/Pulse/ALSA), album art, replaygain, multiple outputs, and smooth client support (ncmpcpp, rmpc, Cantata, etc.).
This works great on **Hyprland** (Wayland doesn’t affect MPD directly).

---

## 1️⃣ Directory layout (recommended)

First, make sure you have this structure:

```bash
mkdir -p ~/.config/mpd
mkdir -p ~/.local/share/mpd/{playlists,db,state,stickers}
```

Music directory example:

```bash
~/Music
```

---

## 2️⃣ Full `mpd.conf`

Save this as:

```bash
~/.config/mpd/mpd.conf
```

```conf
############################
# DIRECTORIES & FILES
############################

music_directory     "~/Music"
playlist_directory  "~/.local/share/mpd/playlists"
db_file             "~/.local/share/mpd/db"
state_file          "~/.local/share/mpd/state"
sticker_file        "~/.local/share/mpd/stickers"
log_file            "~/.local/share/mpd/log"

# Optional PID file (useful if running as a service)
pid_file            "~/.local/share/mpd/pid"

############################
# USER & PERMISSIONS
############################

# Only needed for system-wide MPD
# user "mpd"

############################
# NETWORK
############################

bind_to_address "127.0.0.1"
port "6600"

# Enable this if you want remote clients
# bind_to_address "0.0.0.0"

############################
# AUDIO OUTPUTS
############################

### PipeWire / PulseAudio (BEST for Hyprland)
audio_output {
    type            "pipewire"
    name            "PipeWire Output"
}

# If pipewire output is unavailable, use Pulse:
#audio_output {
#    type            "pulse"
#    name            "PulseAudio Output"
#}

### ALSA (fallback or bit-perfect setups)
#audio_output {
#    type            "alsa"
#    name            "ALSA Output"
#    device          "hw:0,0"
#    mixer_type      "hardware"
#}

### HTTP streaming output (optional)
#audio_output {
#    type            "httpd"
#    name            "MPD Stream"
#    encoder         "vorbis"
#    port            "8000"
#    bitrate         "192"
#    format          "44100:16:2"
#}

############################
# REPLAYGAIN
############################

replaygain                     "album"
replaygain_preamp              "0"
replaygain_missing_preamp      "0"
replaygain_limit               "yes"

############################
# RESAMPLER
############################

audio_buffer_size      "4096"
buffer_before_play     "10%"

############################
# METADATA & TAGS
############################

metadata_to_use        "artist,album,albumartist,title,track,name,genre,date,composer,performer,disc"

############################
# AUTO UPDATE DATABASE
############################

auto_update            "yes"
auto_update_depth      "3"

############################
# FILE FORMATS
############################

decoder {
    plugin "mp3"
    enabled "yes"
}

decoder {
    plugin "flac"
    enabled "yes"
}

decoder {
    plugin "vorbis"
    enabled "yes"
}

decoder {
    plugin "opus"
    enabled "yes"
}

decoder {
    plugin "wav"
    enabled "yes"
}

decoder {
    plugin "aac"
    enabled "yes"
}

############################
# PLAYBACK BEHAVIOR
############################

gapless_mp3_playback   "yes"
restore_paused         "yes"
save_absolute_paths_in_playlists "yes"

############################
# CACHING (IMPORTANT FOR LARGE LIBRARIES)
############################

max_output_buffer_size "16384"

############################
# ALBUM ART
############################

# Enables embedded & folder cover art
filesystem_charset "UTF-8"

############################
# CLIENT COMPATIBILITY
############################

follow_outside_symlinks "yes"
follow_inside_symlinks  "yes"

############################
# SECURITY
############################

password                "changeme@read,add,control,admin"
# Or remove entirely for localhost-only usage

############################
# INPUT PLUGINS
############################

input {
    plugin "curl"
}

############################
# LOGGING
############################

log_level "default"
```

---

## 3️⃣ Start MPD (user service – recommended)

### Run manually (quick test)

```bash
mpd ~/.config/mpd/mpd.conf
```

### Or use systemd user service (best)

Create:

```bash
~/.config/systemd/user/mpd.service
```

```ini
[Unit]
Description=Music Player Daemon
After=pipewire.service sound.target

[Service]
ExecStart=/usr/bin/mpd --no-daemon ~/.config/mpd/mpd.conf
Restart=on-failure

[Install]
WantedBy=default.target
```

Enable it:

```bash
systemctl --user daemon-reexec
systemctl --user enable --now mpd
```

---

## 4️⃣ Update database

```bash
mpc update
```

Check status:

```bash
mpc status
```

---

## 5️⃣ Recommended clients (Hyprland-friendly)

🔥 **Terminal**

* `ncmpcpp` (classic, powerful)
* `rmpc` (modern TUI, Wayland-friendly)

🪟 **GUI**

* **Cantata**
* **ympd** (web UI)

🎹 **Keybindings**
Bind MPD controls in Hyprland:

```ini
bind = SUPER, F9, exec, mpc toggle
bind = SUPER, F10, exec, mpc prev
bind = SUPER, F11, exec, mpc next
```

---

## 6️⃣ Optional extras (worth it)

* **beets** → auto-tag & organize music
* **mpd-mpris** → media keys + Wayland integration
* **playerctl** → control MPD like Spotify

---

If you want, I can:

* Tune this for **bit-perfect audiophile setups**
* Pair it with **ncmpcpp config**
* Add **cover art + lyrics**
* Optimize for **huge libraries (100k+ tracks)**


Just say the word 🎶


Ah yes — **beets** 😌
If you want your music library *clean, tagged, and perfectly organized* for MPD, this is the good stuff.

Below is a **battle-tested beets setup** that plays very nicely with **MPD on Hyprland**, supports album art, lyrics, ReplayGain, and keeps your folders pretty.

---

## 1️⃣ Install beets

```bash
sudo pacman -S beets python-pylast python-requests python-pillow
```

Optional (highly recommended):

```bash
sudo pacman -S chromaprint ffmpeg
```

---

## 2️⃣ Folder layout (recommended)

**Input (messy music):**

```bash
~/Music/Incoming
```

**Managed library (beets owns this):**

```bash
~/Music/Library
```

MPD should point to:

```conf
music_directory "~/Music/Library"
```

---

## 3️⃣ Full-featured `config.yaml`

Create:

```bash
~/.config/beets/config.yaml
```

```yaml
############################
# BASIC SETTINGS
############################

directory: ~/Music/Library
library: ~/.config/beets/library.db

import:
  move: yes
  copy: no
  write: yes
  resume: ask
  incremental: yes
  timid: no
  log: ~/.config/beets/import.log

############################
# FILE & PATH FORMATTING
############################

paths:
  default: $albumartist/$album%aunique{}/$track - $title
  singleton: Singles/$artist/$title
  comp: Compilations/$album/$track - $title

############################
# FORMATTING CLEANUP
############################

replace:
  '[\\/]': _
  '^\.': _
  '[<>:"\?\*\|]': _
  '\s+$': ''
  '^\s+': ''

############################
# TAGGING & MATCHING
############################

match:
  strong_rec_thresh: 0.04
  preferred:
    media: ['CD', 'Digital Media|File']
    countries: ['US', 'GB', 'JP']
    original_year: yes

############################
# ARTWORK
############################

art_filename: cover
fetchart:
  auto: yes
  cautious: yes
  sources:
    - filesystem
    - coverart
    - albumart
    - itunes
    - amazon
  minwidth: 800
  maxwidth: 3000

############################
# EMBED ART & TAGS
############################

embedart:
  auto: yes

############################
# LYRICS
############################

lyrics:
  auto: yes
  sources: musixmatch genius lyricsovh

############################
# REPLAYGAIN
############################

replaygain:
  auto: yes
  backend: ffmpeg
  albumgain: yes
  clip: no

############################
# DUPLICATES
############################

duplicates:
  tiebreak:
    items: [bitrate, samplerate, bitdepth, format]
    albums: [albumtype, year, bitrate]

############################
# FILE TYPE WHITELIST
############################

plugins:
  - autotag
  - fetchart
  - embedart
  - lyrics
  - replaygain
  - lastgenre
  - duplicates
  - scrub
  - missing
  - web
  - info

############################
# GENRES
############################

lastgenre:
  auto: yes
  canonical: yes
  whitelist: yes
  count: 3
  source: track

############################
# SCRUB BAD TAGS
############################

scrub:
  auto: yes

############################
# WEB INTERFACE
############################

web:
  host: 127.0.0.1
  port: 8337
```

---

## 4️⃣ Import workflow (the beets way)

### Drop new music

```bash
mv ~/Downloads/*.flac ~/Music/Incoming
```

### Import (interactive, safe)

```bash
beet import ~/Music/Incoming
```

**Controls during import**

* `a` → accept match
* `e` → edit tags
* `s` → skip
* `u` → use original tags
* `b` → back

Beets will:
✔ Tag correctly
✔ Rename files
✔ Create folders
✔ Embed cover art
✔ Calculate ReplayGain

---

## 5️⃣ MPD sync

After import:

```bash
mpc update
```

MPD sees everything clean & perfect ✨

---

## 6️⃣ Power commands (you’ll love these)

Check missing tags:

```bash
beet missing
```

Find duplicates:

```bash
beet duplicates
```

Retag an album:

```bash
beet import -C -W ~/Music/Library/Artist/Album
```

Fix genres:

```bash
beet lastgenre
```

Open web UI:

```bash
beet web
```

➡ [http://localhost:8337](http://localhost:8337)

---

## 7️⃣ Pro tips for Hyprland + MPD

* Use **MPD ReplayGain album mode**
* Disable volume normalization in clients
* Let beets be the *only* thing that renames music
* Back up `library.db` regularly

---

If you want, I can:

* Make a **minimal beets config**
* Tune it for **classical / jazz**
* Optimize for **huge libraries**
* Add **disc/box-set friendly paths**
* Integrate with **Picard or Lidarr**

Just tell me your vibe 🎧

