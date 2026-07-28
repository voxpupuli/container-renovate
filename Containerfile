FROM docker.io/library/node:24-alpine AS base

ARG NPM_VERSION=12.0.1

RUN npm install --global "npm@${NPM_VERSION}" \
    && npm cache clean --force

###############################################################################

FROM base AS build

WORKDIR /npm
COPY package.json /npm

RUN npm install

###############################################################################

FROM base AS final

LABEL org.label-schema.maintainer="Voxpupuli Team <voxpupuli@groups.io>" \
      org.label-schema.vendor="Voxpupuli" \
      org.label-schema.url="https://github.com/voxpupuli/container-renovate" \
      org.label-schema.name="Vox Pupuli Container for renovate" \
      org.label-schema.license="AGPL-3.0-or-later" \
      org.label-schema.vcs-url="https://github.com/voxpupuli/container-renovate" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Containerfile"

ENV RENOVATE_X_IGNORE_RE2=true

COPY Containerfile /
COPY container-entrypoint.sh /
COPY container-entrypoint.d /container-entrypoint.d
COPY --from=build /npm /npm

RUN apk update && apk upgrade --no-cache \
    && apk add --no-cache --update \
        bash \
        git \
        socat\
    && chmod +x /container-entrypoint.sh /container-entrypoint.d/*.sh

# fix ENOGITREPO Not running from a git repository.
RUN git config --global --add safe.directory '*'

WORKDIR /data

ENV PATH="$PATH:/npm/node_modules/.bin"
ENV NODE_OPTIONS="--use-openssl-ca"

ENTRYPOINT [ "/container-entrypoint.sh" ]
CMD [ "--help" ]
