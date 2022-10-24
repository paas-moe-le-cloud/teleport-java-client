#!/bin/bash

if [ -z "$GIT_BRANCH" ]; then
  echo "GIT_BRANCH is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_USER_NAME" ]; then
  echo "GIT_USER_NAME is undefined." 1>&2
  exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
  echo "GIT_USER_EMAIL is undefined." 1>&2
  exit 1
fi


if [ -z "$GIT_URI" ]; then
  echo "GIT_PUSH_URI is undefined." 1>&2
  exit 1
fi

export M2_HOME=~/.m2

mkdir -p ${M2_HOME}

if [ $? -ne 0 ]; then
    exit 1
fi

pushd src && \
  rm -rf ~/.m2 && \
  ln -fs $(pwd)/m2 ~/.m2 && \
  git config --global user.name "${GIT_USER_NAME}" && \
  git config --global user.email "${GIT_USER_EMAIL}" && \
  git update-ref refs/heads/${GIT_BRANCH} HEAD
  git checkout ${GIT_BRANCH} && \
  git pull --ff-only && \
  git --no-pager log --decorate=short --pretty=oneline && \
  git log $(git describe --tags --abbrev=0)..HEAD --oneline | grep -o " .*" > ../release-notes/release-notes && \
  ./mvnw release:prepare \
    --batch-mode \
    -DautoVersionSubmodules=true && \
  ./mvn release:perform -Darguments="-Dmaven.deploy.skip=true" \
  git describe --tags --abbrev=0 > ../release-version/version