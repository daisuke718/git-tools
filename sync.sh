#!/bin/bash

IFS=$'\n'
for branch in $(git branch | sed -e 's/ //g')
do
  is_current=0
  if [[ $branch = \** ]] ; then
    branch=${branch//\*/}
    is_current=1
  fi
  behind_commit=$(git rev-list --right-only --count "$branch"...origin/"$branch")
  if [ "$behind_commit" -gt 0 ] ; then
    if [ "$is_current" -eq 1 ] ; then
      git pull
    else
      git fetch origin "$branch":"$branch"
    fi
  fi
done

