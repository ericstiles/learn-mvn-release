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



echo "mvn release:clean"
mvn release:clean

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on mvn release:clean"
  exit $SUCCESS
fi


echo "mvn release:prepare"
mvn release:prepare

SUCCESS=$?
if [ $SUCCESS != 0 ]; then
  echo "error $SUCCESS on mvn release:prepare"
  exit $SUCCESS
fi


echo "mvn release:perform"
mvn release:perform

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
