#!/usr/bin/env bash

echo "running release"


if [ "$(git branch | grep '*' | awk '{ print $2 }')" != 'main' ]; then
  echo "switch to main branch"
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "there are changes, please remove address all changes";
  exit 1
fi

echo "no changes, moving forward with release";
echo git checkout release