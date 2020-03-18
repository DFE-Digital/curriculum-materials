#!/usr/bin/env bash
# Bulk converts open document files to pdf and names them according to preview
# naming convention `foo.odt` -> `foo.preivew.pdf`.
# NOTE: unoconv is a bit flaky, so you may need to rerun the script to convert
# any failures!

set -e

type unoconv > /dev/null 2>&1 || { echo >&2 'unoconv is not installed, try:
docker run -v "$(pwd):/tmp/app" --rm -it skylarkelty/docker-unoconv /tmp/app/db/seeds/preview-generator.sh '; exit 1; }

# Settings
to_convert='(.odp|.odt)'
convert_to='.pdf'
start_path="${BASH_SOURCE%/*}/data"
timeout=5

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET_COLOUR='\033[0m'
convert_to_extension=$(echo $convert_to | sed 's/.//')
succeded=0
failed=0
total=0
skipped=0

for file in $(find $start_path | grep -E $to_convert)
do
  total=$((total + 1))
  tempfile=$(echo $file | sed -E "s/$to_convert$/$convert_to/")
  previewfile=$(echo $tempfile | sed "s/$convert_to$/.preview$convert_to/")
  if [[ ! -f $previewfile ]]; then
    # unocov sometimes randomly hangs
    set +e
    timeout $timeout unoconv -f $convert_to_extension $file
    set -e

    if [[ -f $tempfile ]]; then
      mv $tempfile $previewfile
      succeded=$((succeded + 1))
    else
      echo -e "$RED failed to generate preview for $file $RESET_COLOUR"
      failed=$((failed + 1))
    fi
  else
    skipped=$((skipped + 1))
  fi
done
echo -e "total $total $GREEN $succeded succeded $RED $failed failed $RESET_COLOUR skipped $skipped"
