# Python

[![Docker](https://github.com/GamesBoost42/python/actions/workflows/docker.yml/badge.svg)](https://github.com/GamesBoost42/python/actions/workflows/docker.yml)

Base image with pre-installed [pip](https://pypi.org/project/pip/) and [poetry](https://python-poetry.org/) for building Kubernetes applications

## Usage example

Basic `Dockerfile` example:

```Dockerfile
FROM ghcr.io/gamesboost42/python:3.9 AS python3

COPY pyproject.toml poetry.lock ./
RUN poetry install && rm -rf ~/.cache

COPY . .

USER 1042:1042
EXPOSE 8000
CMD ["uvicorn", "main:app", "--port", "8000"]
```
