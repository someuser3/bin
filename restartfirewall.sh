#!/bin/bash

/root/projects/bin/firewall.sh

sleep 30

iptables -F
#iptables -X LAB-8
