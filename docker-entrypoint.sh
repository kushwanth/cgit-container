#!/bin/sh

set -e

# Check for incoming Nginx server commands or subcommands only
if [ "$1" = "nginx" ] || [ "${1#-}" != "$1" ]; then
    if [ "${1#-}" != "$1" ]; then
        set -- nginx "$@"
    fi

    # Generate configuration from environment variables (write to /tmp for rootless access)
    envsubst '$CGIT_TITLE $CGIT_DESC' < /tmp/cgitrc.tmpl > /tmp/cgitrc

    # Start fcgiwrap with specified workers (default 1, max 4)
    WORKERS=${CGIT_WORKERS:-1}
    case "$WORKERS" in
        ''|*[!0-9]*) WORKERS=1 ;;
    esac
    [ "$WORKERS" -lt 1 ] && WORKERS=1
    [ "$WORKERS" -gt 4 ] && WORKERS=4

    spawn-fcgi \
        -s /tmp/fcgiwrap.sock \
        -F "$WORKERS" \
        -- /usr/bin/fcgiwrap \
        & exec "$@"
else
    exec "$@"
fi
