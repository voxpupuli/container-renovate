# Voxpupuli Renovate Container

[![CI](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml/badge.svg)](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml)
[![License](https://img.shields.io/github/license/voxpupuli/container-renovate.svg)](https://github.com/voxpupuli/container-renovate/blob/main/LICENSE)
[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)

## Introduction

This container can be used to update dependencies in your projects.
It encapsulates [renovate](https://github.com/renovatebot/renovate) and all necessary plugins.
See [package.json](package.json) for details. This is a npm application running in an alpine container.
Allthought there is a very good upstream container, this container is based on alpine and much smaller.

## Usage

Main tools in the container:

- renovate

for more information see the [`package.json`](package.json)

### Running the tools

You can run the tools directly using `podman` or `docker`:

```bash
podman run -e LOG_LEVEL=debug --rm -v $PWD:/data:Z ghcr.io/voxpupuli/container-renovate --platform=local --dry-run
```
