Dotfiles Template
=================

This is a template repository for bootstrapping your dotfiles with [Dotbot][dotbot].

To get started, you can [create a new repository from this template][template]
(or you can [fork][fork] this repository, if you prefer). You can probably
delete this README and rename your version to something like just `dotfiles`.

In general, you should be using symbolic links for everything, and using git
submodules whenever possible.

To keep submodules at their proper versions, you could include something like
`git submodule update --init --recursive` in your `install.conf.yaml`.

To upgrade your submodules to their latest versions, you could periodically run
`git submodule update --init --remote`.

Inspiration
-----------

# Modern CLI tools
yay -S exa bat duf procs fd fzf
Here’s a **practical, no-nonsense guide to optimizing rsync and Linux kernel settings for local HDD → HDD rsync** (same machine, spinning disks). I’ll separate **rsync flags**, **I/O scheduling**, **kernel tunables**, and **filesystem considerations**, with example commands.

---

## 1. Rsync options that actually matter for local HDDs

### ✅ Use these

```bash
rsync -a --delete --inplace --numeric-ids --no-compress \
      --info=progress2 --human-readable \
      --whole-file \
      SRC/ DST/
```

**Why:**

* `--whole-file`
  🔥 **Huge win locally** — skips delta algorithm (CPU + random reads)
* `--no-compress`
  Compression is useless locally and wastes CPU
* `--inplace`
  Reduces temp file writes (especially big files)
* `-a`
  Metadata preserved efficiently

---

### ❌ Avoid these for HDDs

* `-z` / `--compress`
* `--checksum` (forces full file reads)
* `--partial-dir` (extra seeks)
* `--link-dest` unless required (metadata overhead)

---

## 2. Control rsync I/O behavior

### Limit metadata storms (important for millions of small files)

```bash
rsync -a --delete --omit-dir-times --no-perms --no-owner --no-group SRC/ DST/
```

Use **only if permissions aren’t important**.

---

### Parallelize safely (advanced, big trees)

For **many small files**, single rsync can be slow. Use GNU Parallel:

```bash
find SRC -mindepth 1 -maxdepth 1 -type d | \
parallel -j 2 rsync -a --delete --whole-file {} DST/
```

⚠️ Do **not** exceed `-j 2` on HDDs or you’ll cause seek thrashing.

---

## 3. Disk scheduler tuning (VERY important for HDD)

### Check current scheduler

```bash
cat /sys/block/sdX/queue/scheduler
```

### Best scheduler for HDD rsync

```bash
echo mq-deadline | sudo tee /sys/block/sdX/queue/scheduler
```

**Why:**

* `mq-deadline` = best balance for sequential + metadata IO
* `bfq` = good for desktops, slower for bulk rsync
* `none` = bad for HDD

---

## 4. Kernel VM tunables for rsync

### Increase dirty writeback limits (big win)

```bash
sudo sysctl -w vm.dirty_background_ratio=5
sudo sysctl -w vm.dirty_ratio=20
```

For large-memory systems (≥32GB), use absolute values:

```bash
sudo sysctl -w vm.dirty_background_bytes=$((512*1024*1024))
sudo sysctl -w vm.dirty_bytes=$((2*1024*1024*1024))
```

**Why:**
Allows rsync to stream writes instead of stalling.

---

### Reduce inode pressure

```bash
sudo sysctl -w vm.vfs_cache_pressure=50
```

Helps when copying **many small files**.

---

## 5. Read-ahead tuning (critical for sequential IO)

### Check current

```bash
blockdev --getra /dev/sdX
```

### Increase for HDD rsync

```bash
sudo blockdev --setra 4096 /dev/sdX
```

(4096 = 2MB readahead)

---

## 6. Mount options (if you can remount)

### EXT4 optimal for rsync

```bash
noatime,nodiratime,commit=60
```

Remount:

```bash
sudo mount -o remount,noatime,nodiratime,commit=60 /mnt/disk
```

⚠️ `commit=60` slightly increases risk on power loss (acceptable for backups).

---

## 7. CPU affinity (optional but useful)

Bind rsync to specific cores to avoid scheduler noise:

```bash
taskset -c 2,3 rsync -a --whole-file SRC/ DST/
```

---

## 8. Example “maximum throughput” rsync command

```bash
rsync -a --delete --whole-file --inplace --no-compress \
      --info=progress2 SRC/ DST/
```

With kernel tuned + scheduler set, this is usually **disk-limited**.

---

## 9. How to tell if it’s optimized

Run:

```bash
iostat -dx 1
```

You want:

* `%util` near **90–100%**
* `await` stable (not spiking wildly)
* Minimal reads during write phase

---
Below is the **clean, correct way to create an “archive” Btrfs subvolume and make it writable by a normal user**, with notes for common pitfalls.

---

## 1. Create the archive subvolume

You must do this as root (or via sudo), and **at the top level of the filesystem** (not inside an existing subvolume unless you intend nesting).

```bash
sudo btrfs subvolume create /mnt/data/archive
```

Verify:

```bash
sudo btrfs subvolume list /mnt/data
```

---

## 2. Mount behavior (important)

By default, subvolumes **inherit mount options** from the parent mount.

Check how your filesystem is mounted:

```bash
mount | grep /mnt/data
```

Typical good options:

```
rw,noatime,ssd?,space_cache=v2,subvolid=5
```

Nothing special is required for writability beyond `rw`.

---

## 3. Make the subvolume writable by a user

Subvolumes behave like directories regarding ownership and permissions.

### Option A – single user owns it (most common)

```bash
sudo chown -R username:username /mnt/data/archive
sudo chmod 755 /mnt/data/archive
```

Now `username` can write freely.

---

### Option B – shared group access (recommended for archives)

```bash
sudo groupadd archive   # if not existing
sudo usermod -aG archive username

sudo chown -R root:archive /mnt/data/archive
sudo chmod 2775 /mnt/data/archive
```

**Why 2775?**

* `2` → setgid bit → new files inherit group
* `775` → group writable

---

## 4. Prevent accidental deletion (optional but smart)

### Immutable directory (root-only removal)

```bash
sudo chattr +i /mnt/data/archive
```

To modify later:

```bash
sudo chattr -i /mnt/data/archive
```

---

## 5. If this is for rsync archives (best practice)

Create **read-only snapshots inside archive**:

```bash
sudo btrfs subvolume snapshot -r /mnt/data/live /mnt/data/archive/live-$(date +%F)
```

User can **read**, root controls snapshots.

---

## 6. Common mistakes to avoid ❌

❌ Trying to `chmod` before `chown`
❌ Mounting archive with `ro`
❌ Creating subvolume inside a snapshot
❌ Using `btrfs property set archive ro true` (makes it read-only!)

Check read-only flag:

```bash
sudo btrfs property get /mnt/data/archive ro
```

Set writable explicitly:

```bash
sudo btrfs property set /mnt/data/archive ro false
```

---

## 7. Recommended archive layout

```
/mnt/data
├── live          (rw subvolume)
├── archive       (rw, user-writable)
│   ├── snap-2025-01-01 (ro snapshot)
│   ├── snap-2025-02-01
```

---
