#!/bin/sh

set -e

mount -t tmpfs tmpfs .

mkdir -p /tmp/overlay-demo/lower /tmp/overlay-demo/upper /tmp/overlay-demo/work /tmp/overlay-demo/merged

mount -t overlay overlay -o lowerdir=/tmp/overlay-demo/lower,upperdir=/tmp/overlay-demo/upper,workdir=/tmp/overlay-demo/work /tmp/overlay-demo/merged

echo "I am the core OS file." > /tmp/overlay-demo/lower/os-release.txt

echo "I am a secret config." > /tmp/overlay-demo/lower/config.txt

echo "I am a new log file." > /tmp/overlay-demo/upper/app.log

echo "I am a MODIFIED core OS file." > /tmp/overlay-demo/upper/os-release.txt

exec "$@"