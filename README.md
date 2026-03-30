# Social Complexity Insights

Social Complexity Insights is a Markdown-first Jekyll blog repository for research-oriented writing at the intersection of computational modeling, complex systems, agent-based modeling, and social dynamics.

The repository combines two layers:

- a human-facing writing layer in `content/posts/`
- a Jekyll publishing layer generated into `_posts/` for GitHub Pages

## What This Repository Contains

- Long-form blog posts and technical essays
- A lightweight static site based on the Clean Blog Jekyll structure
- A small Ruby script that converts source Markdown into Jekyll-compatible posts
- Local preview scripts so the site can be built and inspected before publishing

## Repository Layout

```text
.
├── content/posts/          # Source posts written in plain Markdown
├── _posts/                 # Generated Jekyll posts (ignored except for .gitkeep)
├── assets/                 # Site CSS/JS and post image assets
├── img/                    # Theme/background images used by the site
├── _layouts/               # Jekyll layouts
├── _includes/              # Jekyll includes
├── scripts/                # Post generation and local preview utilities
├── .github/workflows/      # GitHub Pages build/deploy workflow
├── index.md                # Home page
├── about.md                # About page
├── posts/index.html        # Post listing page
└── _config.yml             # Jekyll configuration
```

## Authoring Model

Write posts in `content/posts/` using this format:

- filename: `YYYY-MM-DD-slug.md`
- first non-empty line: level-1 heading such as `# Post Title`
- optional subtitle: the first standalone italic paragraph immediately after the title
- main body: standard Markdown
- images: use repository-relative paths such as `assets/images/...`

Example:

```md
# Example Post Title

*Optional subtitle line.*

Main body text.
```

The script [`scripts/generate_posts.rb`](scripts/generate_posts.rb) converts these source files into Jekyll posts by:

- extracting the title from the first `#` heading
- converting the optional italic subtitle into front matter
- assigning the `post` layout and post date
- rewriting `assets/...` image links into `relative_url` form for GitHub Pages
- regenerating `_posts/*.md` from scratch on each run

## Current Content State

At the current repository state:

- the active source post lives in `content/posts/`
- a generated version is produced in `_posts/`
- a legacy root-level Markdown copy is still present as a local reference artifact:
  `blog-social-systems-01-convenience-autonomy-and-hidden-architectures.md`

The source of truth for authoring should be treated as `content/posts/`, not `_posts/`.

## Local Preview

This repository keeps its Ruby/Jekyll preview runtime local to the project so the blog can be previewed without depending on a global Ruby installation.

One-time bootstrap on a fresh macOS machine:

```bash
./scripts/bootstrap_local_preview.sh
```

Start the local preview server:

```bash
./scripts/preview.sh
```

Preview URL:

```text
http://127.0.0.1:4000/Social-Complexity-Insights/
```

Check the local preview environment:

```bash
./scripts/doctor_local_preview.sh
```

## Local Runtime Details

The preview setup uses repository-local runtime artifacts:

- local Ruby runtime: `.local/ruby-3.2.4/`
- local Bundler config: `.bundle/`
- local gem install path: `vendor/bundle/`

These artifacts are intentionally ignored by Git.

## Publishing Workflow

GitHub Pages deployment is handled by [`pages.yml`](.github/workflows/pages.yml).

On each push to `main`, the workflow:

1. checks out the repository
2. sets up Ruby 3.2
3. runs `ruby scripts/generate_posts.rb`
4. builds the Jekyll site
5. deploys `_site` to GitHub Pages

The site configuration currently uses:

- site URL: `https://stevenbush.github.io/Social-Complexity-Insights/`
- base URL: `/Social-Complexity-Insights`

## Important Notes

- `README.md`, `content/`, and `scripts/` are excluded from the published Jekyll site by `_config.yml`.
- `_posts/*.md` is ignored in Git, so generated posts are build artifacts rather than source-managed content.
- `_site/` is a local build output and is ignored in Git.
- The Clean Blog theme assets under `img/` are still used for page backgrounds.
- Post-specific figures are stored under `assets/images/`.

## Minimal Author Workflow

1. Write or edit a post in `content/posts/`.
2. Run `./scripts/preview.sh`.
3. Inspect the generated site locally.
4. Commit source changes when satisfied.
5. Publish by updating `main` so GitHub Pages rebuilds the site.
