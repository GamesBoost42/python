#!/usr/bin/env bash

if [ ! -r VERSION ]; then
	echo "No version info found" >&2
	exit 1
fi

if [ ! -r SHA256 ]; then
	echo "No source hashsum found" >&2
	exit 1
fi

registry="ghcr.io"
repository="gamesboost"

imageName=$(basename "$(pwd)")
sha256=$(cat SHA256)
version=$(cat VERSION)
buildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
gitBranch=$(git branch --show-current)
gitTag=$(git describe --tags "$(git rev-list --tags --max-count=1)" 2>/dev/null)

fromTag="docker.io/library/python:$version-slim@sha256:$sha256"

if ! docker pull --quiet "$fromTag"; then
	echo "Failed to pull source image" >&2
	exit 1
fi

set -- --no-cache --build-arg SHA256="$sha256" --build-arg VERSION="$version" --build-arg BUILD_DATE="$buildDate"

imageId="$registry/$repository/$imageName"

if [ -z "$gitTag" ]; then
	docker build . --tag "$imageId:$gitBranch" --build-arg VCS_REF="$gitBranch" "$@"
	docker inspect "$imageId:$gitBranch"
	exit $?
fi

set -eu

docker build . \
	--tag "$imageId:$gitTag" \
	--tag "$imageId:$gitBranch" \
	--build-arg VCS_REF="$gitTag" \
	"$@"

docker push "$imageId:$gitBranch"
docker push "$imageId:$gitTag"
