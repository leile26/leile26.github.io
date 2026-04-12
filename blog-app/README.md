# blog-app

This folder contains the Astro-based blog source for Lei Le's website.

## Cheatsheet

### Start a draft

```bash
cd blog-app
./new-draft.sh my-post
```

### Start a bilingual draft pair

```bash
./new-draft.sh my-post -b
```

### Publish a draft

```bash
./publish-post.sh my-post
./push-blog.sh "Publish my-post"
```

For a bilingual pair, publish both:

```bash
./publish-post.sh my-post
./publish-post.sh my-post.zh
./push-blog.sh "Publish bilingual my-post"
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

# Two different preview modes

This project currently has **two different ways** to look at the blog locally.

## Mode 1: Astro dev preview

Run:

```bash
cd blog-app
npm run dev
```

Then open:

- `http://127.0.0.1:4321/blog/`

This preview reads directly from:

- `blog-app/src/pages/blog/`

Use this while writing and editing.

## Mode 2: Synced root-site output

Run:

```bash
./scripts-sync-blog.sh
```

This does **not** start a preview server.
It builds Astro and copies the generated static result into the repo root:

- `../blog/`

Use this when you want to update the root-site blog output that GitHub Pages publishes.

If you want to preview the root-site output locally in one step, use:

```bash
./preview-site.sh
```

That will:

1. run `./scripts-sync-blog.sh`
2. start a static server from the repo root
3. let you open:
   - `http://127.0.0.1:8000/`
   - `http://127.0.0.1:8000/blog/`

## Important difference

- `npm run dev` = preview Astro source directly
- `./scripts-sync-blog.sh` = build and sync the final static output

So it is normal for `./scripts-sync-blog.sh` to succeed without changing what an already-running preview server is showing.

---

# The main idea

## Published posts
Published posts live here:

```bash
src/pages/blog/
```

Anything under `src/pages/blog/*.md` is treated as a real blog post.

For bilingual writing, the recommended pattern is:

- `my-post.md` for English
- `my-post.zh.md` for Chinese

The archive currently treats English as the primary list and shows posts with `lang: en`.
Chinese versions are still published as separate pages and linked from the post page.
Language switches are shown only when the alternate file actually exists.

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

If you want both English and Chinese draft files at once:

```bash
./new-draft.sh your-post-slug -b
```

This creates:

```bash
drafts/your-post-slug.md
drafts/your-post-slug.zh.md
```

Use this when you want to start writing but do **not** want the post to appear publicly yet.

---

## 2. List all drafts

```bash
./list-drafts.sh
```

## 2b. List published posts

```bash
./list-posts.sh
```

Use this when you want to confirm which posts are already in `src/pages/blog/` and should appear in the blog.

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

For a bilingual published pair:

```bash
./new-post.sh your-post-slug -b
```

This creates:

```bash
src/pages/blog/your-post-slug.md
src/pages/blog/your-post-slug.zh.md
```

---

# Template

Reusable post templates are here:

```bash
templates/post-template.md
templates/post-template.zh.md
```

The helper scripts use the English template automatically.
If you want a bilingual pair, create the English post first, then copy the Chinese template and set matching translation fields.

By default, templates now use:

```yaml
alternate: ""
```

This makes it safe to publish English first and add the Chinese version later.

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

If your shell reports `npm: command not found`, the script now also tries `pnpm` and `yarn`, and prints a clearer PATH-related error if no package manager is available.

If your shell reports `sh: astro: command not found`, that usually means `blog-app/node_modules` is missing. The sync script now tries to install dependencies automatically before building when the local Astro binary is absent.

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

## Workflow E: publish an English post with a Chinese version

Example files:

- `src/pages/blog/my-post.md`
- `src/pages/blog/my-post.zh.md`

### Recommended bilingual model

Use English as the primary version and Chinese as the companion version.

That means:

- the main archive lists the English post
- the Chinese version is published as its own page
- the post page can link to the other language when both files exist

### Naming convention

Use the same slug base for both versions:

- English: `my-post.md`
- Chinese: `my-post.zh.md`

### Recommended frontmatter pattern

English first, before Chinese exists yet:

```yaml
lang: en
translationKey: my-post
alternate: ""
```

After Chinese is published:

English:

```yaml
lang: en
translationKey: my-post
alternate: "/blog/my-post.zh/"
```

Chinese:

```yaml
lang: zh
translationKey: my-post
alternate: "/blog/my-post/"
```

### Typical bilingual workflow

#### Option 1: start both drafts at once

```bash
./new-draft.sh my-post -b
```

This creates:

- `drafts/my-post.md`
- `drafts/my-post.zh.md`

#### Option 2: publish English first

If the English version is ready first, publish only English:

```bash
./publish-post.sh my-post
./push-blog.sh "Publish English version of my-post"
```

At this stage:

- the English page is public
- the Chinese page is still a draft
- no language switch is shown unless the Chinese file actually exists in `src/pages/blog/`

#### Option 3: publish Chinese later

When the Chinese version is ready:

```bash
./publish-post.sh my-post.zh
./link-translations.sh my-post
./push-blog.sh "Publish Chinese version of my-post"
```

`./link-translations.sh my-post` automatically fills the matching `alternate` links in both files.

### What appears in the archive

The main archive currently shows English posts only:

- posts with `lang: en` are listed in `/blog/`
- Chinese posts are still published and reachable directly
- if a Chinese version exists, the English post can show that a Chinese version is available

### When to use `link-translations.sh`

Use it only after both files have been published into:

- `src/pages/blog/my-post.md`
- `src/pages/blog/my-post.zh.md`

That is the safest moment to connect the two language versions.

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
- `templates/post-template.md` — English markdown template
- `templates/post-template.zh.md` — Chinese markdown template

## Scripts
- `new-draft.sh` — create a draft
- `list-drafts.sh` — list drafts
- `list-posts.sh` — list published posts
- `publish-post.sh` — move draft to published
- `unpublish-post.sh` — move published post back to drafts
- `remove-post.sh` — delete a post entirely
- `new-post.sh` — create a published post directly
- `scripts-sync-blog.sh` — build + sync generated blog output to root `blog/`
- `push-blog.sh` — safer add/commit/rebase/push helper
- `link-translations.sh` — connect English/Chinese post pairs with matching alternate links

---

# Current architecture

This repo is intentionally using a mixed setup for now:

- root homepage stays in the repo root
- Astro is used only for the blog
- generated blog pages are synced into the root `blog/` folder

This keeps the current site stable without forcing a full migration to Astro.
