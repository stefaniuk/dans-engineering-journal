# stefaniuk.co.uk

Professional blog focusing on software development, technology solutions and engineering best practices by Dan Stefaniuk.

## Overview

A technical blog built with Jekyll that provides insights and practical guidance on software development, systems administration and cloud architecture. The site delivers clear, well-structured content for technology professionals.

## Core Technologies

- Jekyll for static site generation
- HTML/CSS for styling
- Google Analytics for visitor insights
- Disqus for reader engagement
- RSS Feed for content distribution

## Project Organisation

```text
.
├── _drafts/         # Draft blog posts
├── _includes/       # Reusable HTML components
├── _layouts/        # Page templates
├── _posts/          # Published blog posts
├── _sass/           # SCSS style partials
├── about/           # About page
├── css/             # Compiled stylesheets
│   ├── main.css
│   └── terminal.css
├── CNAME           # Custom domain configuration
├── Gemfile         # Ruby dependencies
├── _config.yml     # Jekyll configuration
├── favicon.png     # Site favicon
├── feed.xml        # RSS feed
├── index.html      # Homepage
├── LICENCE.md      # Licence information
├── robots.txt      # Search engine crawler settings
└── sitemap.xml     # Site structure for search engines
```

## Key Features

- Mobile-optimised, responsive layout
- Interactive blog posts with commenting capability
- Content syndication via RSS feed
- Search engine optimisation
- Integrated social media sharing
- Visitor analytics integration

## Development Setup

### Installing Jekyll on macOS

1. Install Bundler and Jekyll

    ```bash
    gem install --user-install bundler jekyll
    ```

2. Install project dependencies

    ```bash
    bundle install
    ```

### Running the site locally

1. Start the Jekyll server:

    ```bash
    bundle exec jekyll serve
    ```

2. Open your web browser and navigate to `http://localhost:4000`

## Copyright Notice

Copyright © Dan Stefaniuk. All rights reserved.
