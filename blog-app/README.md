# blog-app

This folder contains the Astro-based blog source for Lei Le's website.

## Cheatsheet

### Start a draft

```bash
cd blog-app
./new-draft.sh my-post
```

### Publish a draft

```bash
./publish-post.sh my-post
./push-blog.sh "Publish my-post"
```

### Unpublish a post

```bash
./unpublish-post.sh my-post
./push-blog.sh "Unpublish my-post"
```

### Delete a post entirely

```bash
./remove-post.sh my-post
./push-blog.sh "Remove my-post"
```

### Preview locally

```bash
npm run dev
```

---

## What this folder is for

- `blog-app/` = blog source code and writing workflow
- root `blog/` = generated static blog pages that are actually published on GitHub Pages

So when you write a post here, you are editing the **source**. The public site is updated only after the blog is built and synced.

---

# Quick start

## Local development

```bash
cd blog-app
npm install
npm run dev
```

Then open:

- `http://127.0.0.1:4321/blog/`

---

# The main idea

## Published posts
Published posts live here:

```bash
src/pages/blog/
```

Anything under `src/pages/blog/*.md` is treated as a real blog post and will appear in the blog archive.

## Drafts
Drafts live here:

```bash
drafts/
```

Anything in `drafts/` is **not published**.

---

# Most common workflows

## 1. Create a draft

```bash
cd blog-app
./new-draft.sh your-post-slug
```

This creates:

```bash
drafts/your-post-slug.md
```

Use this when you want to start writing but do **not** want the post to appear publicly yet.

---

## 2. List all drafts

```bash
./list-drafts.sh
```

---

## 3. Publish a draft

```bash
./publish-post.sh your-post-slug
```

This moves the file from:

```bash
drafts/your-post-slug.md
```

to:

```bash
src/pages/blog/your-post-slug.md
```

At that point, it becomes a real published post source.

---

## 4. Unpublish a post

If a post is already published and you want to take it down **without deleting the content**, run:

```bash
./unpublish-post.sh your-post-slug
```

This moves the file from:

```bash
src/pages/blog/your-post-slug.md
```

back to:

```bash
drafts/your-post-slug.md
```

Use this when you want to pull a post offline and keep working on it later.

---

## 5. Remove a post entirely

If you want to delete a post completely instead of turning it back into a draft:

```bash
./remove-post.sh your-post-slug
```

This deletes the file from either or both of these locations if present:

- `src/pages/blog/your-post-slug.md`
- `drafts/your-post-slug.md`

---

# Creating a published post directly

If you already know you want to publish immediately, you can create a post directly in the published location:

```bash
./new-post.sh your-post-slug
```

This creates:

```bash
src/pages/blog/your-post-slug.md
```

---

# Template

The reusable post template is here:

```bash
templates/post-template.md
```

The helper scripts use this template automatically.

---

# Local preview vs GitHub automatic sync

## What `./scripts-sync-blog.sh` does

This script does two things:

1. builds the Astro blog
2. copies the generated blog output into the root `blog/` directory of the repo

So this script is basically:

> build the blog and sync the public static output

---

## When you should run `./scripts-sync-blog.sh`

Run it when you want to:

- preview the generated result locally before pushing
- update the root `blog/` directory immediately on your machine
- confirm the exact final static output

```bash
./scripts-sync-blog.sh
```

---

## When you do not have to run it manually

This repo now includes a GitHub Actions workflow that automatically rebuilds the Astro blog and syncs the generated output into the root `blog/` directory when you push `blog-app/` changes.

So if you are fine with GitHub doing the sync after push, you can often skip the local sync step.

---

# Safest day-to-day workflows

## Workflow A: draft first, then publish later

```bash
cd blog-app
./new-draft.sh my-post
# write the draft
./publish-post.sh my-post
./push-blog.sh "Publish my-post"
```

---

## Workflow B: preview locally before pushing

```bash
cd blog-app
./publish-post.sh my-post
./scripts-sync-blog.sh
./push-blog.sh "Publish my-post"
```

---

## Workflow C: take a published post offline

```bash
cd blog-app
./unpublish-post.sh my-post
./push-blog.sh "Unpublish my-post"
```

---

## Workflow D: delete a post completely

```bash
cd blog-app
./remove-post.sh my-post
./push-blog.sh "Remove my-post"
```

---

# Safer push helper

Use this helper when pushing blog-related changes:

```bash
./push-blog.sh "your commit message"
```

It runs:

1. `git add .`
2. `git commit -m ...`
3. `git pull --rebase origin master`
4. `git push`

This is useful because GitHub Actions may add an automatic follow-up sync commit after you push blog source changes.

---

# Build

```bash
npm run build
```

Generated output goes to:

```bash
blog-app/dist/
```

---

# Files in this folder

## Content
- `src/pages/blog/` — published post source
- `drafts/` — unpublished drafts
- `templates/post-template.md` — reusable markdown template

## Scripts
- `new-draft.sh` — create a draft
- `list-drafts.sh` — list drafts
- `publish-post.sh` — move draft to published
- `unpublish-post.sh` — move published post back to drafts
- `remove-post.sh` — delete a post entirely
- `new-post.sh` — create a published post directly
- `scripts-sync-blog.sh` — build + sync generated blog output to root `blog/`
- `push-blog.sh` — safer add/commit/rebase/push helper

---

# Current architecture

This repo is intentionally using a mixed setup for now:

- root homepage stays in the repo root
- Astro is used only for the blog
- generated blog pages are synced into the root `blog/` folder

This keeps the current site stable without forcing a full migration to Astro.
