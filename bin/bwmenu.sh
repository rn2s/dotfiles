#!/bin/bash

ITEM=$(bw list items | jq -r '.[].name' | fzf)

if [ -n "$ITEM" ]; then
    bw get password "$ITEM" | xclip -selection clipboard
    echo "Copied to clipboard"
fi