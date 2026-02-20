# 🏷️ Versioning Strategy

## Overview

This project uses **Semantic Versioning (SemVer)** with automatic version bumping based on commit messages when merging to the `main` branch.

## How It Works

### Automatic Version Bumping

When you merge a feature branch to `main`, the workflow automatically:

1. **Analyzes commit messages** since the last tag
2. **Determines the bump type** (major, minor, or patch)
3. **Creates a new version tag**
4. **Builds and publishes** containers with the new version
5. **Creates a GitHub release** with release notes

### Version Bump Rules

The workflow scans commit messages to determine which version component to bump:

| Commit Message Pattern | Bump Type | Example |
|------------------------|-----------|---------|
| `BREAKING CHANGE` or `major:` | **Major** (x.0.0) | `v1.2.3` → `v2.0.0` |
| `feat:`, `feature:`, or `minor:` | **Minor** (0.x.0) | `v1.2.3` → `v1.3.0` |
| All other commits | **Patch** (0.0.x) | `v1.2.3` → `v1.2.4` |

### Examples

#### Patch Release (Bug fixes, documentation, small changes)
```bash
git commit -m "fix: resolve sensor reading issue"
git commit -m "docs: update README"
git commit -m "chore: update dependencies"
```
**Result:** `v1.2.3` → `v1.2.4`

#### Minor Release (New features, backwards-compatible)
```bash
git commit -m "feat: add temperature alerts"
git commit -m "feature: implement auto-refresh"
```
**Result:** `v1.2.3` → `v1.3.0`

#### Major Release (Breaking changes)
```bash
git commit -m "feat: redesign API

BREAKING CHANGE: API endpoints have changed"
```
**Result:** `v1.2.3` → `v2.0.0`

Or use the `major:` prefix:
```bash
git commit -m "major: complete rewrite of sensor parser"
```
**Result:** `v1.2.3` → `v2.0.0`

## Workflow Triggers

### Main Branch (Automatic Versioning)
- **Trigger:** Push to `main` (typically from merged PRs)
- **Action:** Bumps version, builds containers, creates release
- **Tags:** New semantic version (e.g., `v1.2.4`)
- **Images:**
  - `ghcr.io/michaeltrip/lmsensors-daemonset-container:v1.2.4`
  - `ghcr.io/michaeltrip/lmsensors-daemonset-container:latest`
  - `ghcr.io/michaeltrip/lmsensors-web:v1.2.4`
  - `ghcr.io/michaeltrip/lmsensors-web:latest`

### Feature Branches (Development)
- **Trigger:** Push to `feature/**`, `fix/**`, `chore/**`
- **Action:** Builds containers only (no release)
- **Tags:** Branch-based (e.g., `feature-auth-abc1234`)
- **Images:** `ghcr.io/michaeltrip/lmsensors-daemonset-container:feature-auth-abc1234`

### Pull Requests
- **Trigger:** PR opened/updated to `main`
- **Action:** Builds containers only (no push)
- **Purpose:** CI validation

### Schedule
- **Trigger:** Daily at 16:00 UTC
- **Action:** Rebuilds latest containers
- **Purpose:** Security updates, base image updates

## Best Practices

### 1. Use Conventional Commits
Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>: <description>

[optional body]

[optional footer]
```

### 2. Plan Your Releases
Before merging to `main`, consider:
- What type of changes are included?
- Should this be a major, minor, or patch release?
- Are there breaking changes?

### 3. Squash Merge Strategy
When merging PRs, consider squashing commits and using a clear commit message:

```bash
feat: add real-time sensor monitoring

- Implemented WebSocket connection
- Added auto-refresh every 5 seconds
- Updated UI with live indicator
```

### 4. Review Before Merge
The version bump happens automatically, so ensure:
- All tests pass
- Documentation is updated
- Breaking changes are clearly marked

## Manual Version Override

If you need to create a specific version manually:

```bash
# Create and push a tag manually
git tag v2.0.0
git push origin v2.0.0

# The workflow will use this tag for the next main branch push
```

## Checking Current Version

```bash
# Get the latest version tag
git describe --tags --abbrev=0

# List all version tags
git tag -l "v*" --sort=-version:refname
```

## Troubleshooting

### Release Not Created
Check if:
1. You're pushing to `main` (not a feature branch)
2. There are new commits since the last tag
3. The workflow has `contents: write` permission

### Wrong Version Bumped
Review your commit messages:
- Use `feat:` for features (minor bump)
- Use `BREAKING CHANGE:` in commit body for major bumps
- Regular commits default to patch bumps

### Container Not Tagged
Check the GitHub Actions logs:
1. Go to Actions tab
2. Click on the latest workflow run
3. Review the "Determine tag" step output
