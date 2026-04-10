# blog-app

Astro-based technical blog prototype for Lei Le's website.

## Features
- Markdown posts under `src/pages/blog/*.md`
- LaTeX math via `remark-math` + `rehype-katex`
- Code blocks via Astro markdown pipeline
- Automatic archive generation by scanning markdown files

## Local development

```bash
cd blog-app
npm install
npm run dev
```

Open:
- http://127.0.0.1:4321/blog/
- http://127.0.0.1:4321/blog/math-and-markdown-test/

## Build

```bash
npm run build
```

Generated output goes to `blog-app/dist/`.

## Suggested deployment strategy for this repo

For now, keep the main homepage in the repo root and use Astro only for the technical blog.

A simple deployment flow is:
1. Build Astro in `blog-app/`
2. Copy `blog-app/dist/blog/` into the repo root `blog/`
3. Commit both the root homepage changes and generated blog files

This avoids migrating the whole homepage into Astro right away.
