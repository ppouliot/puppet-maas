#!/bin/bash
MAAS_URL='http://localhost/MAAS/api/2.0'
POD_TYPE='virsh'
POD_NAME=$POD_TYPE-$RANDOM
VIRSH_URL="qemu+ssh://$MAAS_USER@$POWER_ADDRESS/system"
MAAS_USER=$1
POWER_ADDRESS=$1
MAAS_USER=$2
POWER_PASS=$3

maas login $MAAS_USER $MAAS_URL $(maas-region apikey --username=$MAAS_USER)
maas $MAAS_USER pods create -d type=$POD_TYPE name=$POD_NAME power_address=$POWER_ADDRESS power_pass=$POWER_PASS
