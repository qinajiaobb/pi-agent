#!/bin/bash

set -e

PRIME_PROMPT="$(cat ~/brain/*.md 2>/dev/null || echo)"

if [[ ! -z $PRIME_PROMPT ]]; then
  set -x
  exec pi --approve "$(cat ~/brain/*.md)" "$@"
fi

if [[ ! -z "$@" ]]; then
  set -x
  exec pi --approve "$@"
fi

set -x
exec pi --approve
