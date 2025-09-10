# 📝 Conventional Commits Guide

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification for automatic semantic versioning.

## 🚀 Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## 📋 Commit Types

| Type | Description | Version Bump | Example |
|------|-------------|--------------|---------|
| `feat` | New feature | **Minor** | `feat: add temperature alerts` |
| `fix` | Bug fix | **Patch** | `fix: resolve memory leak in sensor collection` |
| `perf` | Performance improvement | **Patch** | `perf: optimize data processing` |
| `refactor` | Code refactoring | **Patch** | `refactor: simplify sensor data parsing` |
| `docs` | Documentation changes | **Patch** | `docs: update installation guide` |
| `style` | Code style changes | **Patch** | `style: fix formatting in web interface` |
| `test` | Test additions/changes | **Patch** | `test: add unit tests for sensor validation` |
| `chore` | Maintenance tasks | **Patch** | `chore: update dependencies` |
| `ci` | CI/CD changes | **Patch** | `ci: improve build performance` |

## 💥 Breaking Changes

Add `!` after the type/scope for breaking changes (triggers **Major** version bump):

```bash
feat!: redesign sensor data API
fix(api)!: remove deprecated endpoints
```

## 🔧 Scopes (Optional)

You can add scopes to provide more context:

- `sensor`: Changes to sensor container
- `web`: Changes to web interface
- `deploy`: Changes to deployment files
- `ci`: Changes to CI/CD pipeline
- `docs`: Documentation changes

## ✅ Good Examples

```bash
# New features
feat: add support for GPU temperature monitoring
feat(web): implement real-time alerts dashboard
feat(sensor): add NVIDIA GPU sensor support

# Bug fixes
fix: resolve container startup race condition
fix(web): correct timezone display in dashboard
fix(deploy): fix persistent volume permissions

# Breaking changes
feat!: migrate to new sensor data format
fix(api)!: remove support for legacy sensor names

# Performance improvements
perf(sensor): reduce memory usage by 30%
perf(web): implement lazy loading for large datasets

# Documentation
docs: add troubleshooting guide
docs(deploy): update Kubernetes requirements

# Chores
chore: update base image to Ubuntu 24.04
chore(deps): bump nginx to latest version
```

## ❌ Avoid These

```bash
# Too vague
fix: bug fixes
feat: improvements

# Wrong type
feat: fix typo in README
fix: add new sensor support

# No description
fix:
feat:
```

## 🏷️ Automated Versioning

Our CI/CD pipeline automatically:

1. **Analyzes** your commit messages
2. **Calculates** the next version number
3. **Creates** a Git tag and GitHub release
4. **Builds** and publishes container images
5. **Updates** deployment files

## 🛠️ Version Examples

Starting from `v1.2.3`:

```bash
fix: resolve sensor timeout issue          → v1.2.4 (patch)
feat: add CPU frequency monitoring         → v1.3.0 (minor)
feat!: redesign configuration format       → v2.0.0 (major)
```

## 📚 Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
