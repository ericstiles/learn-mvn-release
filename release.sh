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

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git checkout release"
  exit $SUCCESS
fi


echo "pulling latest"
git pull origin release

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git pull origin release"
  exit $SUCCESS
fi


echo "rebase main onto release"
git rebase main

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git rebase main"
  exit $SUCCESS
fi

echo "push origin release"
git push origin release

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git push origin release"
  exit $SUCCESS
fi


echo "mvn release:clean"
mvn release:clean --batch-mode

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on mvn release:clean"
  exit $SUCCESS
fi


echo "mvn release:prepare"
mvn release:prepare --batch-mode

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on mvn release:prepare"
  exit $SUCCESS
fi


echo "mvn release:perform"
mvn release:perform --batch-mode

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on mvn release:perform"
  exit $SUCCESS
fi

echo "checkout back to main"
git checkout main

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git checkout main"
  exit $SUCCESS
fi

echo "merge release to main"
git merge release

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git merge release to main"
  exit $SUCCESS
fi

echo "push origin main"
git push origin main

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on git push origin main"
  exit $SUCCESS
fi
