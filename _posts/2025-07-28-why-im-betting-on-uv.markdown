---
layout: post
title: "Why I'm Betting on uv: The Python Package Manager I Wish Existed Years Ago"
date: 2025-07-28 07:22:00 Europe/London
comments: true
---

I started my career working with Java, where tools like Maven made managing dependencies simple and reliable. Everything just worked (more or less). You didn't have to worry about setting up different tools or whether your project would build the same way every time.

As I learned Python, I noticed things weren't as smooth. Python is flexible, but managing environments and dependencies always felt a bit messy compared to Java and Maven. I found myself wishing for something more organised and dependable for Python projects.

That's why [uv](https://github.com/astral-sh/uv) caught my eye (it’s not completely new - it’s been around for a while - but it’s starting to mature). It's a single, modern, and very fast tool that brings everything you need for Python project management into one place. Here's a quick summary of why I think uv is worth considering for your next project.

### What is uv and why should you care?

uv is designed to replace `pip`, `pip-tools`, and `virtualenv` with one tool. If you've ever felt Python package management was awkward compared to tools like `npm` or `yarn`, uv is here to fix that.

You can install it on macOS with:

```bash
brew install uv
```

or use other install methods if you prefer.

If you're used to working with Node.js, uv will feel very familiar - think of it as npm or yarn for Python.

### Quick start and how I got going

What I really like about uv is that most things are simple and just work. Here are a few things I tried:

```bash
# Download and manage multiple Python versions
uv python install 3.10 3.11 3.12 3.13

# See where those versions are installed
uv python dir

# Create a virtual environment in your project
uv venv .venv

# Run Python commands in the venv using uv (no need to manually activate)
uv run python --version

# Set up a new project quickly
uv init --app --name my-app \
 --python 3.12 --managed-python \
 --no-readme --vcs none
```

uv keeps things tidy. You can use different Python versions in different projects, and switching between them is easy.

### My observations

#### What I liked

- **Speed** - installing packages and setting up environments is much faster than with pip and virtualenv.

- **Unified workflow** - one tool for everything, no more switching between different commands or tools.
- **Modern standards** - uv supports `pyproject.toml` by default, making projects more maintainable.
- **Python version management** - easily download and use multiple Python versions, similar to pyenv but more seamless.

#### What's missing or could be improved

- There isn't a single command to update all dependencies to the latest versions (like `yarn upgrade`). For now, you need to update version numbers yourself.

#### Should you switch to uv?

If you want fast, simple, and modern Python project management in one tool, uv is a great choice. It's built with lessons learned from other languages and feels like where Python tooling is heading. It is also supported by a vibrant community with [many contributors and maintainers](https://github.com/astral-sh/uv/graphs/contributors) - usually a good indication of a trend.

If you rely on more advanced features from tools like Poetry, or your workflow is very complex, you might want to keep an eye on uv's progress. But honestly, seeing how good and future-proof uv already is, I'm making the switch for my projects now.
