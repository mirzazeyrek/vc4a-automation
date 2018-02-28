#!/bin/sh
# Automatically merge the last commit through the following branches:
# production -> master -> staging -> development

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
LAST_COMMIT=$(git rev-list -1 HEAD)

echo Automatically merging commit $LAST_COMMIT from $CURRENT_BRANCH rippling to sub-branches

case $CURRENT_BRANCH in
production)
  git checkout master && git merge $CURRENT_BRANCH
  git checkout staging && git merge $CURRENT_BRANCH
  git checkout development && git merge $CURRENT_BRANCH
  git checkout $CURRENT_BRANCH
  ;;
master)
  git checkout staging && git merge $CURRENT_BRANCH
  git checkout development && git merge $CURRENT_BRANCH
  git checkout $CURRENT_BRANCH
  ;;
staging)
  git checkout development && git merge $CURRENT_BRANCH
  git checkout $CURRENT_BRANCH
  ;;
esac