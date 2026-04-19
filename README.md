# admin_toolkit_v3

Bootstrap toolkit for Linux workstations and admin-managed hosts: proxy, package bootstrap, network, time sync, domain join, CIFS mounts, reporting, and post-check validation.

![CI](https://github.com/pagrishaevich/admin_toolkit_v3/actions/workflows/shell-ci.yml/badge.svg)

## What It Solves

This project helps standardize first-run host setup with a small set of Bash scripts that can be adapted for a specific environment without constantly rewriting the core flow.

It is built around three goals:

- predictable bootstrap flow
- safer reruns and more idempotent behavior
- clean separation between core logic and site-specific customization

## Project Layout

```text
scripts/
  bootstrap.sh      # main orchestration
  common.sh         # shared config and helpers
  validate.sh       # local quality checks
custom/
  *.local.sh        # site-specific extensions
config.sh.example   # environment template
```

## Bootstrap Flow

`scripts/bootstrap.sh` runs the toolkit in this order:

1. `self-update`
2. `proxy`
3. `repos`
4. `packages`
5. `network`
6. `time`
7. `autoupdate`
8. `domain`
9. `cifs`
10. `report`
11. `software`
12. `security`
13. `postcheck`

## Quick Start

1. Create local configuration:

```bash
cp config.sh.example config.sh
```

2. Adjust values for your environment.

3. Optionally enable local extensions:

```bash
cp custom/repos.local.sh.example custom/repos.local.sh
cp custom/software.local.sh.example custom/software.local.sh
cp custom/security.local.sh.example custom/security.local.sh
```

4. Run bootstrap as `root`:

```bash
bash scripts/bootstrap.sh
```

## Configuration

Main settings live in `config.sh`.

Common variables:

- `DOMAIN`, `DOMAIN_USER`
- `DNS_SERVERS`, `NTP_SERVER`
- `PROXY`
- `REPORTS_DIR`, `CIFS_SERVER`
- `REPO_DIR`, `AUTO_UPDATE_REMOTE`, `AUTO_UPDATE_BRANCH`
- `TOOLKIT_LOG_FILE`, `REPORT_ARCHIVE_DIR`

If `config.sh` is missing, the toolkit falls back to `config.sh.example`.

## Customization Model

Core scripts stay generic, while environment-specific steps can live in local hooks:

- `custom/repos.local.sh`
- `custom/software.local.sh`
- `custom/security.local.sh`

These hooks are loaded only if the files exist, which keeps the main toolkit reusable across multiple environments.

## Validation

Run local checks with:

```bash
bash scripts/validate.sh
```

The validator always runs `bash -n` and will also run `shellcheck` and `shfmt` when they are installed.

GitHub Actions also runs shell validation on push and pull request.

## Current State

Already improved in this version:

- externalized config template
- safer bootstrap locking
- more consistent `set -euo pipefail`
- more idempotent proxy, domain, and CIFS steps
- safer self-update behavior
- local extension hooks
- shell validation script and CI workflow

Still intentionally lightweight:

- `repos`, `software`, and parts of `security` are extension points by design
- no packaging or installer yet
- no automated integration test environment yet
