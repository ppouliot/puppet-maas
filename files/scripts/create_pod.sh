#!/bin/bash
MAAS_URL='http://localhost/MAAS/api/2.0'
POD_TYPE='virsh'
POD_NAME=$POD_TYPE-$RANDOM
VIRSH_URL="qemu+ssh://$MAAS_USER@$POWER_ADDRESS/system"
MAAS_USER='ubuntu'
POWER_ADDRESS='10.20.20.11'
POWER_PASS='ubuntu'

maas login $MAAS_USER $MAAS_URL $(maas-region apikey --username=$MAAS_USER)
maas $MAAS_USER pods create -d type=$POD_TYPE name=$POD_NAME power_address=$POWER_ADDRESS power_pass=$POWER_PASS

POD_ID=$(maas $PROFILE podss read | grep "^\ \ \ \ \ \ \ \ \"system_id\":" | awk '{print $2}' | sed -e ':a;N;$!ba;s/\n/ /g'| sed -e 's|[",]||g')
