---
layout: post
title: "From Commits to Deployments: Using Conventional Commits, Semantic Versioning, and Build Metadata for Traceable Releases"
date: 2025-09-19 16:32:00 Europe/London
comments: true
---

If you've ever been asked _"What's running in production right now?"_ and found yourself scrolling through Git logs, squinting at CI dashboards, or digging through half-forgotten release notes, you know the pain. How can something as basic as _knowing what's live_ still feel so fragile in 2025?

The truth is, many teams are still working with habits that made sense a decade ago - long-lived branches, manual releases, vague commit messages. But if we're serious about flow, about delivering value to users quickly and safely, we need to rethink the fundamentals. What if _every commit_ could be a clear, traceable unit of change? What if we could deploy multiple times a day, without drowning in meaningless version numbers? What if "release" wasn't a painful ceremony but a simple switch?

That's what this post is about. I'll walk through how I use **[Conventional Commits](https://www.conventionalcommits.org/)**, **[Semantic Versioning](https://semver.org/)**, and a sprinkle of **build metadata** (commit SHAs and pipeline IDs) to bring order to the chaos. And yes, we'll talk about **[feature toggles](https://github.com/NHSDigital/software-engineering-quality-framework/blob/main/practices/feature-toggling.md)** and **[OpenFeature](https://openfeature.dev/)** too, because without them, none of this scales.

## Why Conventional Commits?

Let's start with something deceptively simple: commit messages.

Be honest - how many times have you seen commits like `fix stuff` or `update code`? They might feel harmless, but they erode your history into noise.

Instead, we can adopt **Conventional Commits**, where every commit follows a simple, structured format:

- `feat: add search endpoint`
- `fix: correct typo in response message`
- `chore: update dependencies`

At first glance this might feel bureaucratic. Do we really need rules for commit messages? But here's the thing: structure unlocks automation. Once commit types are predictable, we can auto-generate changelogs, decide version bumps automatically, and scan history without guesswork. That's real flow.

## Semantic Versioning in Practice

Now, let's map those commits to **Semantic Versioning** (SemVer). You've seen versions like `1.4.2` before. The rules are simple:

- **MAJOR** → breaking changes
- **MINOR** → new features (backward compatible)
- **PATCH** → bug fixes

If a dev merges `feat: add search endpoint`, our version bumps from `1.4.2` → `1.5.0`. If we fix a bug, we go `1.5.0` → `1.5.1`. And if we break compatibility, it's `2.0.0`.

Think about that from the consumer's perspective: they get a clear signal about what changed and how risky it is. Isn't that the kind of contract we'd want if _we_ were on the receiving end?

## But What About Deployments Every Day?

Here's where traditional ways of working start to crack. In trunk-based development, you might deploy ten times a day. Do you really want to publish _ten_ new SemVer versions daily? Would that help your users - or just flood them with noise?

This is where **build metadata** comes in. SemVer allows an optional suffix like `+something`:

```plaintext
1.5.0+sha.9f8c2d1
1.5.0+build.456.sha.9f8c2d1
```

To the outside world, it's still `1.5.0`. Clean and simple. But internally, you know exactly which commit and pipeline produced that build. When a bug hits production, you can trace it instantly.

## Making It Real with CI/CD

Let's make this practical. With GitHub Actions, you can generate a version string like:

```bash
VERSION=1.5.0
SHA=$(git rev-parse --short HEAD)
BUILD_ID=$GITHUB_RUN_NUMBER
FULL_VERSION="${VERSION}+build.${BUILD_ID}.sha.${SHA}"
echo "Releasing version: $FULL_VERSION"
```

Now your Docker images can be tagged like this:

```plaintext
myapp:1.5.0
myapp:1.5.0+build.456.sha.9f8c2d1
```

One speaks human. The other speaks traceability. Both point to the same thing.

## Deployment vs Release - They're Not the Same

This is where many teams trip up. They treat _deployment_ and _release_ as synonyms. But are they?

- **Deployment** is a technical act: shipping code into production.
- **Release** is a business act: exposing functionality to users.

With **feature toggles**, you can deploy continuously - even unfinished features - while keeping them hidden. Your users only see changes when you decide to flip the switch.

This means you can ship daily without bumping versions pointlessly. Only when you expose a feature do you decide: is it a **PATCH**, **MINOR**, or **MAJOR** release? That's when the SemVer bump happens.

The result? Flow for engineers, clarity for users.

## Why Feature Toggling Changes Everything

Toggles are more than switches. They're the enabler of modern delivery:

1. **Safe daily deployments** – ship incomplete features without risk.
2. **Decoupled decisions** – deploy anytime, release when ready.
3. **Risk management** – toggle off instantly if something breaks.
4. **Experimentation** – A/B testing, canaries, gradual rollouts.

In NHS England, we call this out explicitly: _feature toggling decouples deployment from release_. Without it, we'd still be shackled to slow release trains, fearing every push to production.

## Enter OpenFeature: A Standard for Flags

But here's a question: do you really want to tie your codebase to a single flag provider forever?

That's where **[OpenFeature](https://openfeature.dev/)** comes in. It's a vendor-neutral standard for feature flags. You write against its API, and plug in whatever backend you want - LaunchDarkly, Flagsmith, Unleash. Swap providers without rewriting your app.

It also gives you hooks, context, and consistent semantics across environments. That's huge for compliance, DevOps, and long-term maintainability.

In practice:

- Deploy daily with OpenFeature flags.
- Release selectively by flipping toggles.
- Keep SemVer bumps aligned with _user-visible_ changes, not raw deployments.

That's how you stay fast _and_ safe.

## GitHub Pull Requests and Conventional Commits

Let's talk about PRs, because that's where discipline starts.

- **PR title = Conventional Commit**. Example:

  ```plaintext
  feat(auth): add JWT-based login
  ```

- **Squash merge only**. Configure GitHub so the squash commit message = PR title.
- **Lint PR titles** with tools like [semantic-pull-requests](https://github.com/zeke/semantic-pull-requests).

This keeps your history clean and automation-ready. No more messy merge commits. No more "WIP" slips into production.

## Wrapping Up

If we want to deliver value daily, the old ways won't cut it. Long-lived branches, vague commits, and heavyweight releases belong in the past.

Instead:

- Write disciplined commits.
- Let SemVer communicate change meaningfully.
- Use build metadata for traceability.
- Deploy continuously, release with toggles.
- Standardise with OpenFeature.

Next time someone asks _"What's running in production right now?"_, you won't need to guess. You'll know. And isn't that exactly the kind of confidence modern engineering should give us?

_Future posts will dive deeper into GitHub PR setups, automating changelogs, and real-world case studies of feature toggling at scale. Stay tuned._
