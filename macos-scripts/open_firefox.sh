#!/usr/bin/env bash

# Detects whether Firefox is running
if ! pgrep -f "Firefox" > /dev/null 2>&1; then
    open -a "/Applications/Firefox.app"
else
    # Create a new window
    script='tell application "Firefox" to create window with default profile'
    ! osascript -e "${script}" > /dev/null 2>&1 && {
        # Git pids for any app with "Firefox" and kill
        while IFS="" read -r pid; do
            kill -15 "${pid}"
        done < <(pgrep -f "Firefox")
        open -a "/Applications/Firefox.app"
    }
fi
