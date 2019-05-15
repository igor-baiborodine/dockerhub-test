#!/bin/bash
set -e

printenv

echo "
cmd: $0
args: $@
Docker user ID:$(id -u)"

exec "$@"
