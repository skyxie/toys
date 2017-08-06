#! /bin/bash

lookback=$(date -u -v $3 +%s)

logs=$(aws logs filter-log-events \
        --log-group-name "$1" \
        --filter-pattern "$2" \
        --start-time "$lookback")

messages=$(echo $logs | jq '.events[] | .message')

unescaped=$(echo $messages | sed 's/^.*\\t//g; s/\\//g ; s/n"$//g')

echo $unescaped | jq '.'

