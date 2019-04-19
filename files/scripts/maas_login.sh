#!/usr/bin/env bash
maas login $1 http://localhost:5240/MAAS/api/2.0 $(maas-region apikey --username=$1)
