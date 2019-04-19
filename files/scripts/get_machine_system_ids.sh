#!/bin/bash
MAAS_URL='http://localhost/MAAS/api/2.0'
PROFILE=admin
maas login $PROFILE $MAAS_URL $(maas-region apikey --username=$PROFILE)
maas $PROFILE machines read | grep "^\ \ \ \ \ \ \ \ \"system_id\":" | awk '{print $2}' | sed -e ':a;N;$!ba;s/\n/ /g'| sed -e 's|[",]||g'
