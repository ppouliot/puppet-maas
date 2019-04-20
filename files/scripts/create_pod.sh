#!/bin/bash
MAAS_URL='http://localhost/MAAS/api/2.0'
POD_TYPE='virsh'
POD_NAME=$POD_TYPE-$RANDOM
PROFILE='admin'
POWER_ADDRESS='qemu+ssh://ubuntu@10.20.20.11/system'
POWER_PASS='ubuntu'
RESOURCE_POOL='maas-ctrl'

#maas login $PROFILE $MAAS_URL $(maas-region apikey --username=$PROFILE)

maas $PROFILE resource-pools create name=$RESOURCE_POOL description="KVM Resources on MAAS Controller"
maas $PROFILE pods create -d type=$POD_TYPE name=$POD_NAME power_address=$POWER_ADDRESS power_pass=$POWER_PASS tags="kvm,virtual" pool="$RESOURCE_POOL" cpu_over_commit_ratio=0.0 memory_over_commit_ratio=0.0 default_storage_pool=default

POD_ID=$(maas $PROFILE pods read | grep "^\ \ \ \ \ \ \ \ \"id\":" | awk '{print $2}' | sed -e ':a;N;$!ba;s/\n/ /g'| sed -e 's|[",]||g')
echo "Pod ID: " $POD_ID
maas $PROFILE pod compose $POD_ID cores="12" memory="8196" architecture="amd64/generic" hostname="juju1" storage="vm_disk:40(default)"

