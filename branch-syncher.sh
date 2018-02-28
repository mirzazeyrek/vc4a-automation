#!/bin/sh
# Automatically merge the last commit through the following branches:
# production -> master -> staging -> development

# always good to know where are we and who are we!
whoami
pwd

CURRENT_BRANCH=$(git branch)
LAST_COMMIT=$(git rev-list -1 HEAD)

echo "Fetching all"
git fetch --all

echo "Automatically merging commit $LAST_COMMIT from $CURRENT_BRANCH rippling to sub-branches"
case $CURRENT_BRANCH in
production)
  git checkout master && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout staging && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout development && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout $CURRENT_BRANCH || ( echo "auto merge failed." && exit 1 )
  ;;
master)
  git checkout staging && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout development && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout $CURRENT_BRANCH || ( echo "auto merge failed." && exit 1 )
  ;;
staging)
  git checkout development && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" || ( echo "auto merge failed." && exit 1 )
  git checkout $CURRENT_BRANCH || ( echo "auto merge failed." && exit 1 )
  ;;
esac