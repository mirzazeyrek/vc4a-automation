#!/bin/sh
# Automatically merge the last commit through the following branches:
# production -> master -> staging -> development

# always good to know where are we and who are we!
whoami
pwd

CURRENT_BRANCH=$1
LAST_COMMIT=$(git rev-list -1 HEAD)
REPOSITORY_URL=$2
REPOSITORY_NAME=${REPOSITORY_URL:20}

git remote set-url origin git@github.com:${REPOSITORY_NAME}
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git checkout -f $CURRENT_BRANCH
echo "Fetching all"
git fetch --all
git pull
echo "Automatically merging commit $LAST_COMMIT from $CURRENT_BRANCH rippling to sub-branches"
case $CURRENT_BRANCH in
production)
  ( git checkout -f master && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ( git checkout -f staging && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ( git checkout -f development && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ;;
master)
  ( git checkout -f staging && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ( git checkout -f development && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ;;
staging)
  ( git checkout -f development && git pull && git merge $CURRENT_BRANCH -m "auto merge with $CURRENT_BRANCH" && git push origin development ) || ( echo "auto merge failed." && exit 1 )
  ;;
esac

git checkout $CURRENT_BRANCH || ( echo "auto merge failed." && exit 1 )