#!/bin/bash

git prune

current_branch=$(git symbolic-ref -q --short HEAD)
git for-each-ref --format='%(refname:short) %(upstream:short) $(upstream:track)' refs/heads | while read branch upstream
do
  if [ -n "$upstream" ]; then
    if [ "$track" = "[gone]" ]; then
      git branch -D $branch
    else
      if [[ "$track" =~ "behind" ]]; then
        if [ "$branch" = "$current_branch" ]; then
          git pull
        else
          git fetch "$branch":"$upstream"
        fi
      fi
    fi
  fi
done

echo "done"
