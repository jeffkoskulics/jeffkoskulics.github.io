# jeffkoskulics.github.io

Personal site and blog. Plain Jekyll, built by GitHub Pages from the
`gh-pages` branch. Everything is Markdown.

Live at <https://jeffkoskulics.github.io>.

## Writing a post

Double-click `scripts/new-post.command`. It asks for a title, creates
`_drafts/<slug>.md` with the front matter already filled in, and opens it.

Write. Drafts are not published, so you can leave one sitting for a week.

When it's ready, double-click `scripts/publish.command`. It lists your drafts,
you pick a number, and it dates the file, moves it to `_posts/`, commits, and
pushes with the same retry-with-backoff behaviour as the other scripts on this
machine. The site rebuilds in about a minute.

That's the whole loop: **new-post → write → publish**.

## Front matter

```yaml
---
title: "The title, in quotes"
description: >-
  One or two sentences. Shows on the writing index and in link previews.
tags: [metrology, debugging]
---
```

`layout: post` is applied automatically — you don't need to write it.
Put `<!--more-->` after the opening paragraphs if you want to control the
excerpt. `date` is set from the filename when you publish.

## Layout

| Path | What it is |
|---|---|
| `index.md` | Front page and the statement |
| `about.md` | About page |
| `blog.md` | The writing index, generated from `_posts/` |
| `_posts/` | Published posts, named `YYYY-MM-DD-slug.md` |
| `_drafts/` | Unpublished work. Not built, not visible |
| `_layouts/` | Page templates |
| `assets/css/style.css` | All the styling. Light and dark, one file |
| `scripts/` | `new-post.command`, `publish.command` |

## Editing by hand

Nothing depends on the scripts. A post is just a Markdown file in `_posts/`
with a dated filename, and `git push` publishes it.

## Previewing locally (optional)

Not required — GitHub Pages builds the real thing. If you want a local preview
you need Ruby and Bundler, which this machine does not have set up:

```bash
bundle install
bundle exec jekyll serve
```

Pushing a draft-quality post and fixing it in the next commit is usually
cheaper than maintaining a local Ruby toolchain here.
