FROM docker.io/library/python:3.9.2-slim@sha256:38bc45ae1b48cb0e8726d601b4a8774b9033770afe7bc51c341f643ffb841a27 AS python-base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=true \
    POETRY_NO_ANSI=true \
    VENV_PATH=/app/.venv \
    APP_ROOT=/app \
    PATH=/app/.venv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN set -eux \
  ; mkdir -p $APP_ROOT \
  ; pip install --no-cache-dir --upgrade pip==21.0.1 poetry==1.1.5 \
  ; python --version \
  ; pip --version \
  ; poetry --version \
  ; useradd \
      --comment "Kubernetes application" \
      --create-home \
      --home-dir /home/app \
      --uid 1042 \
      --user-group \
      --shell /bin/bash \
      app \
  ; rm -rf ~/.cache ~/.config \
  ; rm -f /home/app/.bash_logout ~/.wget-hsts ~/.python_history

WORKDIR $APP_ROOT
