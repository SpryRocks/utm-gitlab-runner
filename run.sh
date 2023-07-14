#!/usr/bin/env bash

# /opt/utm-driver/run.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base script.

VM_IP=$(_get_vm_ip)

ssh -i ${currentDir}/guest.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o BatchMode=yes ${VM_USER}@${VM_IP} /bin/bash --login < "${1}"
if [ $? -ne 0 ]; then
    # Exit using the variable, to make the build as failure in GitLab
    # CI.
    exit "$BUILD_FAILURE_EXIT_CODE"
fi
