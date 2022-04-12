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

echo "checkout release branch"
git checkout release

echo "rebase main onto release"
git rebase main

echo "mvn release:clean"
mvn release:clean

echo "mvn release:prepare"
mvn release:prepare

echo "mvn release:perform"
mvn release:perform

echo "checkout back to main"
git checkout main