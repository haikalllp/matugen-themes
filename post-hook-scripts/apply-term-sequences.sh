#!/usr/bin/env bash
SEQUENCES="${1:?Usage: $0 <sequences-file>}"

if [[ ! -f "$SEQUENCES" ]]; then
    echo "Sequences file not found: $SEQUENCES" >&2
    exit 1
fi

for tty in /dev/pts/[0-9]*; do
    cat "$SEQUENCES" > "$tty" 2>/dev/null || true
done

pkill -USR1 -x kitty 2>/dev/null || true
