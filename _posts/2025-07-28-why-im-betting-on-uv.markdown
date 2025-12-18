---
layout: post
title: "Why I'm Betting on uv: The Python Package Manager I Wish Existed Years Ago"
date: 2025-07-28 07:22:00 Europe/London
last_modified_at: 2025-12-18 23:29:00 Europe/London
display_last_modified: true
tags: [uv, python, tools, learning]
comments: true
---

I started my career working with Java, where tools like Maven made managing dependencies simple and reliable. Everything just worked (more or less). You didn't have to worry about setting up different tools or whether your project would build the same way every time.

When I started using Python, things weren't quite as smooth. Python is powerful and flexible, but managing environments and dependencies always felt messy compared to Java and Maven. I often wished for something more predictable and organised.

That's why [`uv`](https://github.com/astral-sh/uv) caught my eye. It's not entirely new, it's been around for a while, but it's really starting to mature. `uv` brings together everything needed for Python project management into one modern, fast tool. Here's why I think it's worth serious consideration.

## What is uv and why should you care?

`uv` is designed to replace `pip`, `pip-tools`, and `virtualenv` with a single command-line tool. If you've ever thought Python's packaging story felt clunky compared to Node's npm or yarn, uv is what you've been waiting for.

You can install it on macOS with:

```bash
brew install uv
```

or follow other [installation instructions](https://github.com/astral-sh/uv?tab=readme-ov-file#installation) from the uv GitHub page.

If you've used Node.js before, uv will feel familiar, it's like npm for Python - dependency management, environment isolation, and builds in one.

## Quick start and how I got going

The biggest compliment I can give uv is that it just works.
Here are a few examples of how I got started:

```bash
# Download and manage multiple Python versions
uv python install 3.12 3.13 3.14

# Pin a global default Python version
uv python pin --global 3.14

# See where Python versions are stored
uv python dir

# Create a virtual environment in the project folder
uv venv .venv

# Run Python inside the environment (no manual activation)
uv run python --version

# Bootstrap a new app quickly
uv init --app --name my-app \
  --python 3.14 --managed-python \
  --no-readme --vcs none
```

uv keeps things tidy. You can use different Python versions in different projects, and switching between them is easy.

## My initial observations

### What I liked

- Speed, installing dependencies and syncing environments is much faster than pip and virtualenv.
- One tool for all tasks, no juggling between pip, pip-tools, and virtualenv.
- Modern by default, everything is `pyproject.toml`-based.
- Built-in Python management, like pyenv, but integrated.

### What could improve

- There's still no single command to bump all dependencies to their latest versions (like `yarn upgrade`). For now, you have to update version numbers manually.

### Should you switch to uv?

If you want a fast, simple, and unified Python development workflow, uv is a great choice. It's already production-ready and has an active community of maintainers and contributors.

If you rely heavily on advanced Poetry-style features, it's worth testing first. But uv feels like the direction Python tooling is heading. For my projects, the switch has already paid off.

## My everyday usage flow

I now use uv daily and settled into a repeatable flow that keeps things clean and reproducible.

```bash
# Start fresh, remove old environment and lock files
rm -rf .venv uv.lock requirements.txt

# Sync dependencies based on pyproject.toml (creates a new .venv and uv.lock)
uv sync

# Inspect dependency tree
uv tree

# Keep .toml and .txt files in sync if you need the legacy requirements files
uv pip compile pyproject.toml --output-file requirements.txt

# Run a script directly
uv run python ./path/to/script.py

# Run tests with dev dependencies
uv sync --extra dev
uv run pytest

# In Visual Studio Code go to:
# Command Palette (⇧⌘P) → "Python: Select Interpreter"
# and choose `./.venv/bin/python` located in your project
```

A minimal working `pyproject.toml` example:

```toml
[project]
name = "my-app"
version = "0.1.0"
description = "Add your description here"
requires-python = ">=3.14"
dependencies = ["loguru>=0.7.3"]

[dependency-groups]
dev = ["pytest"]
```

This setup, one clear `pyproject.toml` and a consistent uv flow, has made my Python work much smoother. I no longer worry about drifting environments or mismatched dependencies.

## Working with multi-package projects in `uv`

As my projects grow, I split them into separate components such as `core`, `api`, and `cli`. This is where I discovered one of uv's best features, [workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/)!

Workspaces let you manage several packages inside a single repository, with one lockfile, shared tooling, and clear internal dependencies. Here's how I've been using them.

### 1. Create a top-level workspace

At the repository root, define a workspace in your `pyproject.toml`:

```toml
[tool.uv.workspace]
members = ["core", "cli", "api"]
```

Each folder (`core`, `cli`, `api`) will have its own `pyproject.toml`, but they'll share one virtual environment and one `uv.lock`. This keeps the setup unified and avoids dependency duplication.

You can initialise these packages easily:

```bash
uv init core
uv init cli
uv init api
```

Then create the rest of the folder structure:

```bash
mkdir -p \
  core/src/core core/tests \
  cli/src/cli cli/tests \
  api/src/api api/tests
touch core/src/core/__init__.py core/tests/test_core.py
touch cli/src/cli/__init__.py cli/tests/test_cli.py
touch api/src/api/__init__.py api/tests/test_api.py
```

### 2. Link internal dependencies explicitly

If one package depends on another, for example, `cli` uses functions from `core` tell uv to link them locally at the top-level `pyproject.toml`:

```toml
[tool.uv.sources]
core = { workspace = true }
```

This tells uv to use your workspace version of `core` instead of fetching it from PyPI. Without this mapping, uv would assume `core` is an external dependency and try to install it from the registry.

### 3. Keep configuration DRY (Don't Repeat Yourself)

For shared tools such as `pytest`, `ruff`, `mypy`, and `black`, define them only once in the root `pyproject.toml`:

```toml
[project.optional-dependencies]
dev = ["pytest", "ruff", "black", "mypy"]

[tool.pytest.ini_options]
testpaths = ["core/tests", "cli/tests", "api/tests", "tests"]
addopts = "-ra -q"
```

This setup keeps your test and lint configuration consistent across all packages. Each sub-package automatically uses these tools when you run `uv sync --extra dev`. Keep in mind that uv commands, especially `uv sync` and `uv run`, should be executed from the root workspace directory, not from within an individual package. That's how uv resolves shared dependencies and applies your top-level configuration correctly.

### 4. Handle imports cleanly in `src/` layouts

If you're following the `src/` layout (e.g. `core/src/core`), Python needs to know where to find those modules. You can fix this by adding to the root pytest config:

```toml
[tool.pytest.ini_options]
pythonpath = ["core/src", "api/src", "cli/src"]
```

This makes imports like `from core import something` work during test discovery.

### 5. Versioning without duplication

You don't need to define `__version__` manually in every package. Instead, read it directly from your project metadata:

```python
from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version(__name__)
except PackageNotFoundError:
    __version__ = "0.0.0"
```

This small snippet keeps the version in sync with your `pyproject.toml` automatically. It's one of those "set it once and forget it" improvements that make the workspace cleaner.

### 6. Organise integration and cross-package tests at the root

Place integration tests that touch multiple packages in a shared folder at the repository root:

```plaintext
tests/
├── test_integration_api_core.py
└── test_integration_cli_core.py
```

Since your root pytest config already points to all test folders, running tests from the top-level works out of the box:

```bash
uv run pytest
```

This makes it easy to test your system as a whole without leaving the workspace root.

## Effective project structure

The layout below shows a clean, maintainable multi-package setup using uv workspaces. This pattern scales well for modular back-end systems, internal libraries, and CLI utilities that need to evolve together but remain logically separate.

```plaintext
.
├── api/                             # package: API
│   ├── src/api/
│   │   └── __init__.py              # API package root
│   ├── tests/
│   │   └── test_api.py              # unit tests for API
│   └── pyproject.toml               # package-level metadata
│
├── cli/                             # package: CLI
│   ├── src/cli/
│   │   └── __init__.py              # CLI package root
│   ├── tests/
│   │   └── test_cli.py              # unit tests for CLI
│   └── pyproject.toml               # package-level metadata
│
├── core/                            # package: Core business logic
│   ├── src/core/
│   │   └── __init__.py              # Core package root
│   ├── tests/
│   │   └── test_core.py             # unit tests for Core
│   └── pyproject.toml               # package-level metadata
│
├── tests/                           # root-level integration tests
│   ├── test_integration_api_core.py # cross-package integration test
│   └── test_integration_cli_core.py # cross-package integration test
│
├── .env.default                     # example environment variables
├── .gitignore                       # git ignore rules
├── .python-version                  # pinned Python version
├── Makefile                         # developer & CI/CD shortcuts (build, test, clean, etc.)
├── pyproject.toml                   # workspace root config (defines uv workspace)
└── README.md                        # project overview and documentation
```

## Final takeaway

uv's workspace model has become one of its most powerful (and underrated) features. It keeps multi-package repositories clean, removes duplication, and makes local development feel seamless.

For me, it's the first time Python tooling has felt coherent across a full stack of packages, the kind of "batteries included" experience I wish we'd always had.
