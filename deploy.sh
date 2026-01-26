
#!/usr/bin/env bash
# usage: deploy.sh <artifact_glob> <env>
set -euxo pipefail
ARTIFACT_GLOB=${1:?"artifact glob required"}
ENV=${2:-dev}
TARGET="deploy/${ENV}"
mkdir -p "$TARGET"
for f in $ARTIFACT_GLOB; do
  cp "$f" "$TARGET"/
  echo "Deployed $f to $TARGET"
done
