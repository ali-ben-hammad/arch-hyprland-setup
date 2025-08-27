#!/bin/bash
CURRENT=$(playerctl status --format "{{playerName}}" 2>/dev/null || echo "No player")
PLAYER_COUNT=$(playerctl --list-all | wc -w)

if [ $PLAYER_COUNT -gt 1 ]; then
    echo "◀ $CURRENT ▶"
else
    echo "$CURRENT"
fi