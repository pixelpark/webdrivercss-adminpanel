#!/bin/bash

set -e   # fail immediately on ALL errors

export REPOSITORY=webdrivercss-adminpanel

if test -f ./version.json ; then    # if we can use the Jenkins generated version.json
  export GIT_COMMIT=${GIT_COMMIT:-$(grep commit version.json|grep -v previos_commit|cut -d\" -f4)}
  export GIT_BRANCH=${GIT_BRANCH:-$(grep branch version.json|cut -d\" -f4)}
else # if we can't use version.json
  export GIT_COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
  export GIT_BRANCH=${GIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
fi

# remove origin/ from GIT_BRANCH and swap all / with _
export GIT_BRANCH=$(echo $GIT_BRANCH|sed 's/origin\///g'|sed 's/\//\_/g')
export DOCKER=${DOCKER:-/usr/bin/docker}
export USERNAME=${USERNAME:-pixelpark}
export REGISTRY=${REGISTRY:-registry.prometheus.pixelpark.net:5000}
export SHARED_DIR=${SHARED_DIR:-/srv/mesos/shared}
export DOCKER_BUILD_OPTS=${DOCKER_BUILD_OPTS:-"--tag=$REPOSITORY"}
export DOCKER_RUN_OPTS=${DOCKER_RUN_OPTS:-"-v $SHARED_DIR:$SHARED_DIR"}

export TAG=${TAG:-$GIT_BRANCH-$GIT_COMMIT}

echo Building "$REPOSITORY":"$TAG".
"$DOCKER" build $DOCKER_BUILD_OPTS .

echo Tagging.
"$DOCKER" tag --force=true "$REPOSITORY" "$REGISTRY"/"$REPOSITORY":latest
"$DOCKER" tag --force=true "$REPOSITORY" "$REGISTRY"/"$REPOSITORY":"$TAG"

echo Pushing.
"$DOCKER" push "$REGISTRY"/"$REPOSITORY":"$TAG"
"$DOCKER" push "$REGISTRY"/"$REPOSITORY":latest
