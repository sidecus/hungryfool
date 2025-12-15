---
author: ["sidecus"]
title: Docker Cache Mount - uv as an Example
date: 2025-12-15T17:44:20+08:00
description: ""
tags: ["docker","devcontainers"]
categories: ["Engineeering", "DevOps"]
ShowToc: true
TocOpen: false
draft: false
---

Docker’s `--mount=type=cache` looks simple on the surface, but it hides an important mental model that often trips people up—especially when mixing **root vs non-root users**, **different home directories**, or **multi-stage builds**.

This post explains **how cache mounts actually work**, **why they don’t share by default**, and **how to correctly share them**, using `uv` as a concrete example.

---

## How `--mount=type=cache` Actually Works

Consider this Dockerfile instruction:

```dockerfile
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync
```

When Docker executes this, it creates a **named cache volume**. The cache is keyed by:

1. The **builder instance**
2. The **target path** (`/root/.cache/uv`)
3. An **optional cache ID** (if you provide one)

Now compare it with:

```dockerfile
RUN --mount=type=cache,target=/home/vscode/.cache/uv \
    uv sync
```

Even if:
- it’s the same Dockerfile
- same base image
- same machine
- same `uv.lock`

Docker treats this as a **completely different cache**.

**Different target path = different cache volume**

So these **do not share** cache:

- `/root/.cache/uv` ❌  
- `/home/vscode/.cache/uv` ❌  

---

## Why Docker Behaves This Way (Important Mental Model)

Cache mounts are **not filesystem overlays**.

They are **explicit cache volumes**, and Docker intentionally isolates them unless you tell it otherwise.

The simplified mental model is:

```
cache-key = (builder, cache-id OR target-path)
```

If you:
- change users
- change home directories
- change paths

…you’ve implicitly changed the cache key.

This design avoids accidental cache corruption, but it means **sharing is opt-in**, not automatic.

---

## How to Force Cache Sharing (The Correct Way)

To share cache across users, paths, stages, or images, you must use an **explicit cache ID**.

### Example

```dockerfile
RUN --mount=type=cache,id=uv-cache,target=/root/.cache/uv \
    uv sync
```

Later:

```dockerfile
RUN --mount=type=cache,id=uv-cache,target=/home/vscode/.cache/uv \
    uv sync
```

Now Docker sees:

- Same `id=uv-cache`
- Different target paths
- ✅ **Same underlying cache volume**

This is the **intended and supported way** to share caches across users (root / non-root), paths, stages, images.

---

## Best Practice for `uv` Cache Mounts

For `uv`, the cleanest approach is to **standardize the cache directory** across images:

```dockerfile
ENV UV_CACHE_DIR=/cache/uv

RUN --mount=type=cache,id=uv-cache,target=/cache/uv \
    uv sync
```

This avoids:
- Permission mismatches
- User home directory confusion
- Accidental cache fragmentation

---

## One Subtle but Critical Detail: Permissions

If you share a cache between **root** and **non-root** users, permissions matter.

If the cache directory isn’t writable (or at least readable) by both, you’ll see:

- `permission denied` errors
- wheels not reused
- silent cache misses

A pragmatic solution during build:

```dockerfile
RUN --mount=type=cache,id=uv-cache,target=/cache/uv \
    chmod -R 0777 /cache/uv || true
```

This ensures the cache remains usable regardless of UID.

---

## TL;DR

| Scenario | Cache Shared? |
|--------|---------------|
| Different targets, no `id` | ❌ No |
| Same target path | ✅ Yes |
| Different targets, same `id` | ✅ Yes |
| Different users, same `id` | ✅ Yes |

**Rule of thumb:**  
👉 *If you want sharing, always set `id` explicitly.*

---

## Follow-Up: Dev Containers Caveat

This only applies to **build-time caches**. You **cannot** use Docker cache mounts as runtime mounts inside containers e.g. dev containers.

For example, this **will not work**:

```json
// devcontainer.json
"mounts": [
  "type=cache,id=uv-cache,target=/cache/uv"
]
```

Cache mounts:
- exist only during `docker build`
- do not persist into running containers
- behave the same for application containers and dev containers

You *can* make cache mounts work when **building** a dev container, but that requires referencing a `Dockerfile` in `devcontainer.json`, which adds complexity.
Compared to this, personally I prefer letting **all dev containers share `uv` cache from the host** using a volume mount at runtime instead.

```json
// devcontainer.json
"containerEnv": {
    "UV_CACHE_DIR": "/uvcache"
},
"mounts": [
    "source=${localEnv:UV_CACHE_DIR},target=/uvcache,type=bind,consistency=cached"
]
```

Simpler, faster, fewer surprises.
