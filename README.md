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

How I use git worktrees
10 Oct 2022 • 5 minute read •

#

git

Git worktrees are extremely powerful. In short, they allow you to checkout a branch into a specific directory. Then, you can checkout another branch into another directory. From here, switching branches is as simple as switching directories! This is essential for developers who might be working on several things at once or who are regularly interrupted and need to switch to a bug fix or even just need to review some code.

The most basic use of a git worktree is to simply checkout a branch using the following command.
Terminal window

`git worktree add -b feature-branch origin/main ../feature-branch`

This will create a new directory as a sibling to your normal working directory, create a branch called feature-branch, and set the inital state of the branch to be that of origin/main. Inside this new directory will be the exact project checked out where you can run all of the normal git commands and set up the project as normal.

You’ll need to npm install or do whatever to set up your project as you normally would, as if this were a new clone.

One thing I don’t like about this setup is the “scatteredness” of my repo with one seemingly blessed worktree and then a bunch of siblings that are outside of that worktree. Instead, I like to use a bare repo setup. In this, the project is checked out without a working tree, similar to how it would be on GitHub and elsewhere.
Terminal window

```shell
▷ git clone --bare git@github.com:nicknisi/dotfiles.git dotfiles
Cloning into bare repository 'dotfiles'...
remote: Enumerating objects: 6464, done.
remote: Counting objects: 100% (1418/1418), done.
remote: Compressing objects: 100% (603/603), done.
remote: Total 6464 (delta 913), reused 1154 (delta 796), pack-reused 5046
Receiving objects: 100% (6464/6464), 3.44 MiB | 10.71 MiB/s, done.
Resolving deltas: 100% (3715/3715), done.

~/Developer/test
▷ cd dotfiles

~/Developer/test/dotfiles
▷ ll
.rw-r--r-- 173 nicknisi  7 Oct 10:36  config
.rw-r--r--  73 nicknisi  7 Oct 10:36  description
.rw-r--r--  21 nicknisi  7 Oct 10:36  HEAD
drwxr-xr-x   - nicknisi  7 Oct 10:36  hooks
drwxr-xr-x   - nicknisi  7 Oct 10:36  info
drwxr-xr-x   - nicknisi  7 Oct 10:36  objects
.rw-r--r-- 287 nicknisi  7 Oct 10:36  packed-refs
drwxr-xr-x   - nicknisi  7 Oct 10:36  refs
```

As you can see in here, we now have the files that would normally appear in the .git/ directory directly inside the directory we made when cloning the repository. So far that doesn’t seem better! From here, we could create a new worktree with the command above and it would appear inline with all of these important-looking git files, which adds a lot of confusion. Instead, we can hide the .git files inside of another directory when we bare clone the repository. I like to call this directory .bare.
Terminal window

```shell
▷ mkdir -p ~/Developer/dotfiles
▷ git clone --bare <git@github.com>:nicknisi/dotfiles.git .bare

# create a new directory for the repository

▷ mkdir project && cd project

# glone the repository (bare) and hide it in a hidden direcotry

▷ git clone --bare <git@github.com>:user/project.git .bare

# create a `.git` file that points to the bare repo

▷ echo "gitdir: ./.bare" > .git
```

The benefit of this setup is that the bare repo contents are hidden away in .bare, and then the directory containing that effectively becomes a place to create worktrees associated with that bare repo, thanks to the .git file, which is a pointer to where the git database is located.

From here, new worktrees can be created and maintained like normal. However, there are a few small issues because when a bare repo is cloned remote-tracking branches are not created. So, when trying to git fetch, no remote branches are fetched. This can be fixed with a few commands to update what happens on fetch and to associate local branches with the their remote.
Terminal window

```shell
▷ git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
▷ git fetch
▷ git for-each-ref --format='%(refname:short)' refs/heads | xargs -n1 -I{} git branch --set-upstream-to=origin/{}
```

I created a script to help make this setup easier.
The downsides

While I think this setup is fantastic and I don’t see myself going back to the old, single woking directory lifestyle, there are a few downsides that you should be aware of.
Each worktree is effectively its own project

Each worktree exists independently of the other. This is obviously a good thing because it means you can run them independently and simultanously, it also means that you need to npm install (or your equivelant) on every one of them. This means that the creation and setup of each worktree can be an ordeal. For my main work project, npm install takes about 5 minutes 😱.
The output of git branch is pretty useless

Looking to see what branches you have created locally becomes more of an ordeal because the git branch command will list every branch that exists in the bare clone.
Terminal window

▷ git --no-pager branch | wc -l
    1520

How I use worktrees to get things done

I will use my git bare-clone script to set up a new, bare repository ready-to-go for creating multiple worktrees. In the way I work, I will create a new worktree for each feature that I am working on, meaning I will have several worktrees that I regularly prune with git worktree remove. However, there are a few stable worktrees that I will perpetually keep around in a project.

    main - The main worktree simply contains the main branch checked out. It’s the easiest way to run the current known good state. I can run this side-by-side with my feature branch worktree to compare and contrast functionality on the fly.
    review - This is a worktree that I’ll use to check out a pull request I am reviewing so that I can test it, run it, run its tests, etc. I’ll use the fantastic gh pr checkout 1234 command from the GitHub CLI to check out PRs easily into this worktree.
    hotfix - this worktree is reserved for quickly creating hotfix PRs in. I keep this around because I want to quickly jump in and start working rather than creating a new feature-branch worktree and then waiting for the long, long npm install to finish.

Quickly creating new worktrees

To save time, I made a helper script that I use to create new worktrees for each feature branch. This is mostly straightforward, and the main benefit this gives me is to automatically create and push a remote feature branch, kick off npm install, and kick off a build of my project. It can take several minutes to complete, but it’s set and forget and then I can come back to a fully up-and-running worktree, ready to be worked!
Conclusion

Using git worktrees are a big change to how I approach development on large projects where I’m involved in lots of different ways including feature work, reviews, and hotfixes. There’s good and bad to them, but for me, the good outweighs the bad and I don’t see myself ever going back!

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
gpg --list-secret-keys --keyid-format=long
