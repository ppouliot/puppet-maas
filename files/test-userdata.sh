#!/bin/bash
MAAS_USER='admin'
MAAS_URL='http://localhost/MAAS/api/2.0'

NODE_UUID='node-03837b1a-ba2e-11e5-b060-001ec946ee0b'
NODE_NAME='c2-r13-u09.maas'
NODE_IP='10.13.1.85'

#maas login $MAAS_USER $MAAS_URL `maas-region-admin apikey $MAAS_USER --username $MAAS_USER` && \
maas login $MAAS_USER $MAAS_URL $(maas-region apikey --username=$MAAS_USER)

#maas admin http://10.5.1.39/MAAS `maas-region-admin apikey maas0.openstack.tld --username admin`
#maas $MAAS_USER node release $NODE_UUID && \
#sleep 3 && \
maas $MAAS_USER nodes acquire agent_name=$NODE_NAME && \
sleep 3 && \
maas $MAAS_USER node start $NODE_UUID user_data=$(base64 --wrap=0 /root/user-data/basic.yaml) && \
sleep 3 && \
ssh-keygen -f "/root/.ssh/known_hosts" -R $NODE_IP
