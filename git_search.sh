#! /usr/bin/env bash

term=$1
branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

for commit in $(git rev-list $branch)
do
  if git show $commit | grep "^[+-].*$term"; then
    echo $commit
    exit 0
  fi
done
