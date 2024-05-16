#!/bin/bash

git prune

current_branch=$(git symbolic-ref -q --short HEAD)
git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads | while read branch upstream
do
  if [ -n "$upstream" ]; then
    behind_commit=$(git rev-list --right-only --count "$current_branch"...origin/"$current_branch") 
    if [ "$behind_commit" -gt 0 ]; then
      if [ "$branch" = "$current_branch" ]; then
        git pull
      else
        git fetch "$branch":"$upstream"
      fi
    fi
  else
    if [ "$branch" != "$current_branch" ]; then
      git branch -D $branch
    fi
  fi
fi

echo "done"
