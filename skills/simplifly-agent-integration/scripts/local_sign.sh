#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${CODE:-}" ]]; then
  echo "Missing CODE environment variable." >&2
  exit 1
fi

if [[ -z "${API_KEY:-}" ]]; then
  echo "Missing API_KEY environment variable." >&2
  exit 1
fi

TS="${TS:-$(date -u +%s)}"
SIG="$(printf "%s" "${CODE}${TS}${API_KEY}" | shasum -a 1 | awk '{print $1}')"

printf 'TS=%s\nSIG=%s\n' "${TS}" "${SIG}"
