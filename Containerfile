FROM docker.io/library/node:24-alpine AS base

ARG NPM_VERSION=12.0.1

RUN npm install --global "npm@${NPM_VERSION}" \
    && npm cache clean --force

###############################################################################

FROM base AS build

WORKDIR /build
RUN apk add --no-cache --update \
    jq \
    patch

RUN export RENOVATE_VERSION=$(wget -qO - https://api.github.com/repos/renovatebot/renovate/releases/latest | jq -r .tag_name) \
    && wget -qO - https://github.com/renovatebot/renovate/archive/refs/tags/${RENOVATE_VERSION}.tar.gz | tar xzf - \
    # feat(manager/puppet): support metadata.json dependencies (see https://github.com/renovatebot/renovate/pull/38055)
    && wget -q https://patch-diff.githubusercontent.com/raw/renovatebot/renovate/pull/38055.patch \
    # feat(github): add support for pinning dependency dashboard issue (see https://github.com/renovatebot/renovate/pull/47717)
    && wget -q https://patch-diff.githubusercontent.com/raw/renovatebot/renovate/pull/47717.patch \
    && mv renovate-${RENOVATE_VERSION} renovate \
    && cd renovate \
    && patch -p1  < ../38055.patch \
    && patch -p1  < ../47717.patch \
    && npx pnpm install \
    && npx pnpm version ${RENOVATE_VERSION}-voxpupuli \
    && npx pnpm build \
    && npx pnpm prune --prod

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
COPY --from=build /build/renovate /usr/local/renovate

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        bash \
        yq \
        git \
        openssh-keygen \
        openssh-client-default \
        gpg \
        socat \
    && chmod +x /container-entrypoint.sh /container-entrypoint.d/*.sh \
    && ln -sf /usr/local/renovate/dist/renovate.js /usr/local/bin/renovate \
    && ln -sf /usr/local/renovate/dist/config-validator.js /usr/local/bin/renovate-config-validator

# fix ENOGITREPO Not running from a git repository.
RUN git config --global --add safe.directory '*'

WORKDIR /data

ENV NODE_OPTIONS="--use-openssl-ca"

ENTRYPOINT [ "/container-entrypoint.sh" ]
CMD [ "--help" ]
