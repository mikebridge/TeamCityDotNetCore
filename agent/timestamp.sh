#!/bin/bash

set -e

TAG=$(git describe --abbrev=0 --tags)

RESULT=$(git log -1 HEAD --date=iso-strict --format="{%n  \"commit\":\"https://github.com/MyName/MyRepo/commit/%H\",%n  \"build\":\"$TAG\",%n  \"date\":\"%aI\",%n  \"user\":\"%an\",%n  \"email\":\"%ae\"%n}")

echo $RESULT
