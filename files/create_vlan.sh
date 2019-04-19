#!/usr/bin/env bash
$PROFILE='admin'
$FABRIC_ID='0'
$VLAN_NAME=
maas $PROFILE vlans create 0 name="Storage network" vid=100
