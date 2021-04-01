ARG SHA256
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

FROM docker.io/library/python:${VERSION}-slim@sha256:${SHA256}

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL architecture="amd64/x86_64" \
      \
      org.opencontainers.image.title="Python" \
      org.opencontainers.image.description="Slim image with Python for building Kubernetes applications" \
      org.opencontainers.image.vendor="GamesBoost42" \
      org.opencontainers.image.url="https://github.com/GamesBoost42/python" \
      org.opencontainers.image.source="https://github.com/GamesBoost42/python.git" \
      org.opencontainers.image.documentation="https://github.com/GamesBoost42/python/blob/master/README.md" \
      org.opencontainers.image.authors="https://github.com/GamesBoost42" \
      org.opencontainers.image.licenses="MIT" \
      \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.created=${BUILD_DATE}

ENV APP_ROOT="/app" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHON_GET_PIP_SHA256= \
    PIP_NO_COLOR=1 \
    PIP_NO_INPUT=1 \
    PIP_QUIET=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

COPY --chown=root:root entrypoint.sh /usr/bin/docker-entrypoint

RUN set -eux \
  ; chmod 0755 /usr/bin/docker-entrypoint \
  ; mkdir -p "$APP_ROOT" \
  ; useradd \
      --comment "Kubernetes application" \
      --create-home \
      --home-dir /home/app \
      --uid 1042 \
      --user-group \
      --shell /bin/bash \
      app \
  ; rm -rf \
      ~/.cache \
      ~/.config \
  ; rm -f \
      ~/.wget-hsts \
      ~/.python_history \
      /home/app/.bash_logout

WORKDIR $APP_ROOT

ENTRYPOINT ["docker-entrypoint"]
CMD ["bash"]
