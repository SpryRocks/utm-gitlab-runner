#!/usr/bin/env bash

# /opt/utm-driver/prepare.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base script.

# Copy base disk to use for Job.
utmctl clone ${BASE_VM_ID} --name ${CLONE_VM_NAME}

# Set unique Network settings
/usr/bin/osascript $(dirname $0)/utm-net-set.scpt "${CLONE_VM_NAME}"

# Start VM
date
utmctl start ${CLONE_VM_NAME}

date
/usr/bin/osascript $(dirname $0)/utm-net-get.scpt "${CLONE_VM_NAME}"


# Wait for VM to get IP
date
echo 'Waiting for VM to get IP'

for i in $(seq 1 30); do
    VM_IP=$(_get_vm_ip)

    if [ -n "$VM_IP" ]; then
        echo "VM got IP: $VM_IP"
        break
    fi

    if [ "$i" == "30" ]; then
        echo 'Waited 30 seconds for VM to start, exiting...'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1
done

date
# Wait for ssh to become available
echo "Waiting for sshd to be available"
for i in $(seq 1 30); do
    if ssh -i ${currentDir}/guest.pem -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o ConnectTimeout=1 ${VM_USER}@${VM_IP} echo "ok" 2>/dev/null; then
        break
    fi

    if [ "$i" == "30" ]; then
        echo 'Waited 30 seconds for sshd to start, exiting...'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1
done

date
