# Voxpupuli Renovate Container

[![CI](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml/badge.svg)](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml)
[![License](https://img.shields.io/github/license/voxpupuli/container-renovate.svg)](https://github.com/voxpupuli/container-renovate/blob/main/LICENSE)
[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)

## Introduction

This container can be used to update dependencies in your projects.
It encapsulates [renovate](https://github.com/renovatebot/renovate) and all necessary plugins.
See [package.json](package.json) for details.
This is a npm application running in an alpine container.
Allthought there is a very good upstream container, this container is based on alpine and much smaller.
It is build on base of `node:22.20.0-alpine3.22` (maybe updated in the future, see [Containerfile](Containerfile)).
We would like to use newer node, but renovate depends on 22.x.

## CVEs

The CVE-Score is quite low.
Trivy reports no CVEs at all at the moment.
But this may change, but compared

```text
# Tue Oct 14 10:09:55 AM CEST 2025

ghcr.io/voxpupuli/renovate:41.146.4-latest (alpine 3.22.2)
==================================================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)

ghcr.io/renovatebot/renovate:latest (ubuntu 24.04)
==================================================
Total: 1249 (UNKNOWN: 0, LOW: 71, MEDIUM: 1177, HIGH: 1, CRITICAL: 0)
```

## Usage

Main tools in the container:

- renovate

for more information see the [`package.json`](package.json)

### Running renovate locally

You can run renovate directly using `podman` or `docker` on your local:

```bash
podman run -e LOG_LEVEL=debug --rm -v $PWD:/data:Z ghcr.io/voxpupuli/container-renovate --platform=local --dry-run
```

### GitLab intigration

see [.gitlab-ci.yml](.gitlab-ci.yml)
