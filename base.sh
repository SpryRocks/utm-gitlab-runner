#!/usr/bin/env bash

# /opt/utm-driver/base.sh
VM_USER="admin"
BASE_VM_ID="75FD7B47-78F7-46CE-BA58-BAFCF7E97B13"
CLONE_VM_NAME="runner-${CUSTOM_ENV_CI_RUNNER_ID}-project-${CUSTOM_ENV_CI_PROJECT_ID}-concurrent-${CUSTOM_ENV_CI_CONCURRENT_PROJECT_ID}-job-${CUSTOM_ENV_CI_JOB_ID}"

echo $CLONE_VM_NAME
_get_vm_ip() {
    VM_MAC=`/usr/bin/osascript /Users/user/gitlab-utm/utm-net-get.scpt "${CLONE_VM_NAME}"`
    #/usr/sbin/arp -a -l -i bridge100 | grep `echo $VM_MAC` | awk '{print $1}'
    cat /var/db/dhcpd_leases | grep -m 1 -B 1 `echo $VM_MAC | sed s/:0/:/g | sed s/^0//g ` | head -1 | awk -F "=" '{print $2}'
}
