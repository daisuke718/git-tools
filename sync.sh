#!/bin/bash

git remote prune origin

current_branch=$(git symbolic-ref -q --short HEAD)
git for-each-ref --format='%(refname:short) %(upstream:short) %(upstream:track)' refs/heads | while read branch upstream track
do
  if [ -n "$upstream" ]; then
    if [ "$track" = "[gone]" ]; then
      if [ "$branch" != "$current_branch" ]; then
        git branch -D $branch
      fi
    else
      if [[ "$track" =~ "behind" ]]; then
        if [ "$branch" = "$current_branch" ]; then
          git pull
        else
          remote=$(echo "$upstream" | cut -d'/' -f1)
          remote_branch=$(echo "$upstream" | cut -d'/' -f2-)
          git fetch "$remote" "$remote_branch":"$branch"
        fi
      fi
    fi
  fi
done

echo "done"
