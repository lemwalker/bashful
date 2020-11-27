#!/bin/bash
token='PUSHBULLET ACCESS TOKEN'
url="https://api.pushbullet.com/v2/pushes"
if [[ -z "$1" ]]; then
    printf "Cannot send empty Push\n" >&2
    printf "USAGE:  %s '%s'\n" "$0" "Message"  >&2
    exit 1
fi
pb_command=$(printf "curl -u '%s:' '%s' -d type=note -d title='%s'" "$token" "$url" "$1")
eval "$pb_command" > /dev/null 2>&1 &&  printf "Message pushed: '%s'\n" "$1"  || printf "Push failed\n" >&2

