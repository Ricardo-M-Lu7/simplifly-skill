#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SIMPLIFLY_CODE:-}" ]]; then
  echo "Missing SIMPLIFLY_CODE environment variable." >&2
  exit 1
fi

if [[ -z "${SIMPLIFLY_API_KEY:-}" ]]; then
  echo "Missing SIMPLIFLY_API_KEY environment variable." >&2
  exit 1
fi

TS="${TS:-$(date -u +%s)}"
SIG="$(printf "%s" "${SIMPLIFLY_CODE}${TS}${SIMPLIFLY_API_KEY}" | shasum -a 1 | awk '{print $1}')"

printf 'TS=%s\nSIG=%s\n' "${TS}" "${SIG}"
