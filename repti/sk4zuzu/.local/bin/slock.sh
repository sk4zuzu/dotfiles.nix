#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

if which slock; then
    slock
fi
