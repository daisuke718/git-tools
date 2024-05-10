#!/bin/bash

git prune

current_branch=$(git branch -vv | grep "\[" | grep -v " gone" | grep "\*" | awk '{print $2}')
if [ -n "$current_branch" ] ; then
  behind_commit=$(git rev-list --right-only --count "$current_branch"...origin/"$current_branch") 
  if [ "$behind_commit" -gt 0 ] ; then
    git pull
  fi
fi

for branch in $(git branch -vv | grep "\[" | grep -v "\*" | awk '{print $1}')
do
  gone_remote=$(git branch -vv | grep " $branch .* gone")
  if [ -n "$gone_remote" ] ; then
    git branch -D $branch
  else 
    behind_commit=$(git rev-list --right-only --count "$branch"...origin/"$branch")
    if [ "$behind_commit" -gt 0 ] ; then
      git fetch origin "$branch":"$branch"
    fi
  fi
done

