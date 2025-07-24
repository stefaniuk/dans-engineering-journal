# stefaniuk.co.uk

Welcome to the repository for [stefaniuk.co.uk](stefaniuk.co.uk) - my professional technology blog, serving as both a public knowledge base and a live record of my ongoing journey through software engineering, cloud architecture, and technical leadership. This site is where I openly share discoveries, deep technical dives, hands-on tutorials, and candid reflections on both success and setbacks.

- [stefaniuk.co.uk](#stefaniukcouk)
  - [Purpose \& Philosophy 🎯](#purpose--philosophy-)
  - [Technology Stack ⚙️](#technology-stack-️)
  - [Structure 🗂️](#structure-️)
  - [Key Features 🌟](#key-features-)
  - [Local Development \& Contribution 🧑‍💻](#local-development--contribution-)
    - [Prerequisites 📦](#prerequisites-)
    - [Installing Jekyll on macOS 🍏](#installing-jekyll-on-macos-)
    - [Running the site locally 🖥️](#running-the-site-locally-️)
    - [Building Static Files 🏗️](#building-static-files-️)
    - [Using Make Commands 🛠️](#using-make-commands-️)
  - [License 📄](#license-)


## Purpose & Philosophy 🎯

This blog is designed not just as a personal archive, but as a practical resource for fellow engineers, architects, and technology enthusiasts. My intention is to foster a culture of learning, knowledge sharing, and open dialogue across the professional community.

My intention is that you will find here the following:

- 🛠️ Real-world solutions, articles addressing concrete technical challenges, grounded in practical experience.
- 🧠 Deep technical exploration, content that examines architectural decisions, design trade-offs, and underlying principles—not just the “how”, but also the “why”.
- 🗣️ Clear, accessible communication, complex concepts are broken down into simple language, making advanced topics approachable.
- 🌱 Professional growth, honest documentation of my learning process, including mistakes and lessons learned, so that others can benefit from my experience.
- 🤝 Open collaboration, a space for feedback, alternative perspectives, and professional networking.

Each article and update represents my commitment to:

- 🔬 Thorough research and exploration
- ✍️ Clear, concise documentation
- 🪞 Transparency about both successes and challenges
- 📈 Continuous learning and improvement

Whether you are an experienced technologist or early in your career, you’ll find authentic insights and actionable knowledge to support your own professional development.

## Technology Stack ⚙️

This site is powered by modern, open-source tools to ensure portability, extensibility, and ease of contribution:

- 🌐 Jekyll – static site generation and content management
- 🎨 HTML/CSS – custom theming and responsive layouts
- 📊 Google Analytics – anonymous visitor insights
- 💬 Disqus – interactive comments and discussion
- 📰 RSS Feed – content syndication for readers and aggregators

## Structure 🗂️

```text
.
├── _drafts/         # Unpublished, in-progress posts
├── _includes/       # Reusable HTML partials
├── _layouts/        # Page and post templates
├── _posts/          # Published blog entries
├── _sass/           # SCSS partials for styling
├── about/           # About and profile pages
├── css/             # Compiled CSS (main/terminal themes)
├── CNAME            # Custom domain configuration
├── Gemfile          # Ruby/Jekyll dependencies
├── _config.yml      # Jekyll site configuration
├── favicon.png      # Site icon
├── feed.xml         # RSS feed for syndication
├── index.html       # Homepage
├── LICENCE.md       # Licence and copyright details
├── robots.txt       # Search engine crawler settings
└── sitemap.xml      # SEO and discoverability
```

## Key Features 🌟

- 📱 Mobile-first, responsive design for a seamless reading experience on any device
- 💬 Interactive commenting via Disqus for community engagement
- 🔔 RSS/Atom feed for automatic content updates
- 🚀 Search engine optimisation (SEO) built-in
- 📢 Integrated social media sharing
- 📈 Real visitor analytics (privacy-respecting)

## Local Development & Contribution 🧑‍💻

You are encouraged to reuse, adapt, or contribute to this blog’s content and technical setup. All scripts and configuration are provided for easy local development and automation.

### Prerequisites 📦

- 💎 Ruby (2.7.0 or newer)
- 📦 RubyGems (comes with Ruby)
- 🛠️ make (standard on macOS/Linux)

### Installing Jekyll on macOS 🍏

1. Install Bundler and Jekyll

    ```bash
    gem install --user-install bundler jekyll
    ```

2. Install project dependencies

    ```bash
    bundle install
    ```

### Running the site locally 🖥️

1. Start the Jekyll server:

    ```bash
    bundle exec jekyll serve
    ```

2. Open your web browser and navigate to `http://localhost:4000`

### Building Static Files 🏗️

1. To generate the static files for production:

    ```bash
    JEKYLL_ENV=production bundle exec jekyll build
    ```

   This will create the static site in the `_site` directory.

2. For development builds with draft posts:

    ```bash
    JEKYLL_ENV=development bundle exec jekyll build --drafts
    ```

### Using Make Commands 🛠️

The project includes several helpful make commands:

- `make serve-drafts` - Start local server with draft posts (development)
- `make serve-live` - Start local server without drafts (production)
- `make clean` - Remove generated files and caches
- `make update` - Clean and rebuild the site
- `make publish` - Build and publish to GitHub Pages

## License 📄

This work is licensed under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License](https://creativecommons.org/licenses/by-nc-nd/4.0/). For full license terms, please see [LICENCE.md](LICENCE.md).

Copyright © 2016-2025 Dan Stefaniuk. All rights reserved.
