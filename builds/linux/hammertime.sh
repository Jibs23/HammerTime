#!/bin/sh
printf '\033c\033]0;%s\a' HammerTime
base_path="$(dirname "$(realpath "$0")")"
"$base_path/hammertime.x86_64" "$@"
