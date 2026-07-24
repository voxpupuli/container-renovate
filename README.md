# Voxpupuli Renovate Container

[![CI](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml/badge.svg)](https://github.com/voxpupuli/container-renovate/actions/workflows/ci.yaml)
[![License](https://img.shields.io/github/license/voxpupuli/container-renovate.svg)](https://github.com/voxpupuli/container-renovate/blob/main/LICENSE)
[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)

## Information

⚠️ as of `Fri Dec 12 2025` we only will build the latest version of renovate.
This will be done twice a day at 08:00 and 16:00 UTC.

Renovate itself pushes updates so frequently, pinning to a specific version is not very useful.

## Introduction

This container can be used to update dependencies in your projects.
It encapsulates [renovate](https://github.com/renovatebot/renovate) and all necessary plugins.
See [package.json](package.json) for details.
This is a npm application running in an alpine container.
Allthought there is a very good upstream container, this container is based on alpine and much smaller.

## CVEs

The target is to have a container with no CVEs.
It is regularly updated and build with the latest renovate version.

for more information see the [Container vulnerability scan issue](https://github.com/voxpupuli/container-renovate/issues/158)

## Usage

Main tools in the container:

- renovate
- renovate-config-validator

for more information see the [`package.json`](package.json)

### Running renovate locally

You can run renovate directly using `podman` or `docker` on your local system:

```bash
podman run -e LOG_LEVEL=debug --rm -v $PWD:/data:Z ghcr.io/voxpupuli/container-renovate --platform=local --dry-run
```

### GitLab integration

see [.gitlab-ci.yml](.gitlab-ci.yml)

### Config validation

```console
cd demo/something/foo
podman run -it --rm -v $PWD:/data:Z --entrypoint renovate-config-validator ghcr.io/voxpupuli/renovate:latest
 INFO: Validating renovate.json
 INFO: Config validated successfully against 1 file(s)
```

### dry-run

```console
cd demo/something/foo
podman run -it --rm -v $PWD:/data:Z ghcr.io/voxpupuli/renovate:latest --dry-run --platform=local
Running /container-entrypoint.d/999_git_add_safe_directory.sh
 INFO: Renovate started
       "renovateVersion": "43.255.2"
 WARN: cli config dryRun property has been changed to full
 INFO: Repository started (repository=local)
       "renovateVersion": "43.255.2"
 INFO: Dependency extraction complete (repository=local)
       "stats": {
         "managers": {
           "leiningen": {"fileCount": 1, "depCount": 71},
           "regex": {"fileCount": 3, "depCount": 21}
         },
         "total": {"fileCount": 4, "depCount": 92}
       }
 INFO: Repository finished (repository=local)
       "cloned": undefined,
       "durationMs": 11603,
       "result": undefined,
       "status": undefined,
       "enabled": undefined,
       "onboarded": undefined
 INFO: Renovate was run at log level "info". Set LOG_LEVEL=debug in environment variables to see extended debug logs.
```
