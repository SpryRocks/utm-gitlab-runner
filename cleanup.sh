#!/usr/bin/env bash

# /opt/utm-driver/cleanup.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base script.

set -eo pipefail

# Destroy VM.
utmctl stop ${CLONE_VM_NAME} --kill

# Delete VM disk.
/usr/bin/osascript ${currentDir}/utm-del.scpt ${CLONE_VM_NAME}
