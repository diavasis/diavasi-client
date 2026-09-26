#!/usr/bin/env bash
set -euo pipefail
version=$(python3 - <<'PY'
import tomllib
print(tomllib.load(open("Cargo.toml", "rb"))["package"]["version"])
PY
)
tag="${GITHUB_REF_NAME:-}"
if [[ -n "$tag" && "$tag" != "v${version}" ]]; then
  echo "tag ${tag} does not match package version ${version}" >&2
  exit 1
fi
if [[ "${DRY_RUN:-0}" == 1 ]]; then
  cargo publish --dry-run --locked
  exit 0
fi
if [[ -z "${CARGO_REGISTRY_TOKEN:-}" ]]; then
  echo "CARGO_REGISTRY_TOKEN is not set" >&2
  exit 1
fi
for attempt in 1 2 3 4 5 6; do
  if cargo publish --locked; then
    exit 0
  fi
  echo "publish failed (attempt ${attempt}), waiting for the index"
  sleep 20
done
exit 1
