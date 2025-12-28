Good choice. Pill groups are cleaner and easier to scan.
Here’s the **correct way to do grouped pill-style modules in Waybar** without hacks.

This assumes you already have sane defaults (like in the normalized config).

---

## 🔹 Concept (no fluff)

* Individual modules → **no margins, no borders**
* Groups → **own the background, padding, radius**
* First + last module in a group get rounded corners
* Middle modules stay flat

Waybar gives you `.modules-left|center|right`, so we group by **position**, not module name.

---

## 1️⃣ Strip styling from individual modules

This is mandatory.

```css
.modules-left > *,
.modules-center > *,
.modules-right > * {
    background: transparent;
    border: none;
    margin: 0;
    padding: 4px 10px;
    font-size: 16px;
    color: @textcolor1;
}
```

---

## 2️⃣ Define the pill group container

This is the actual pill.

```css
.modules-left,
.modules-center,
.modules-right {
    background-color: @backgrounddark;
    border: 3px solid @bordercolor;
    border-radius: 999px;

    margin: 3px 15px;
    padding: 2px;

    opacity: 1.0;
}
```

Now every side of the bar is a pill group.

---

## 3️⃣ Round only the edges inside the group

This keeps things visually tight.

```css
.modules-left > widget:first-child > * {
    border-top-left-radius: 999px;
    border-bottom-left-radius: 999px;
}

.modules-left > widget:last-child > * {
    border-top-right-radius: 999px;
    border-bottom-right-radius: 999px;
}

.modules-center > widget:first-child > * {
    border-top-left-radius: 999px;
    border-bottom-left-radius: 999px;
}

.modules-center > widget:last-child > * {
    border-top-right-radius: 999px;
    border-bottom-right-radius: 999px;
}

.modules-right > widget:first-child > * {
    border-top-left-radius: 999px;
    border-bottom-left-radius: 999px;
}

.modules-right > widget:last-child > * {
    border-top-right-radius: 999px;
    border-bottom-right-radius: 999px;
}
```

Yes it’s verbose. Waybar’s GTK tree forces this.

---

## 4️⃣ Optional: subtle separators (recommended)

Without this, dense groups blur together.

```css
.modules-left > widget:not(:last-child) > * ,
.modules-center > widget:not(:last-child) > * ,
.modules-right > widget:not(:last-child) > * {
    border-right: 1px solid alpha(@bordercolor, 0.3);
}
```

---

## 5️⃣ Workspace exception (they’re already pills)

Let workspaces manage themselves.

```css
#workspaces {
    background: transparent;
    border: none;
    padding: 0 4px;
}
```

---
Q
## Result

* Clean macOS-style pill groups
* No double borders
* One background per group
* Zero per-module duplication

---

## Hard truth

If you try to do pill groups **per module**, you’ll fight GTK forever.
Group at the container level or don’t bother.

If you want next:

* Multiple pills per side (e.g. *system | media | tray*)
* Dynamic group coloring
* Animated separators

Say which one and I’ll wire it properly.
