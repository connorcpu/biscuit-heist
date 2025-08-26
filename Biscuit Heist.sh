#!/bin/sh
echo -ne '\033c\033]0;Biscuit Heist\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Biscuit Heist.x86_64" "$@"
