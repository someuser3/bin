#!/bin/bash

# Create a new iptables chain
iptables -N LAB-8

# Allow inbound ssh connections
iptables -A LAB-8 -p tcp --dport 22 -j ACCEPT

# Allow inbound salt connections
iptables -A LAB-8 -p tcp --dport 4505 -j ACCEPT
iptables -A LAB-8 -p tcp --dport 4506 -j ACCEPT

# Allow DNS connections
iptables -A LAB-8 -p tcp --dport 53 -j ACCEPT
iptables -A LAB-8 -p udp --dport 53 -j ACCEPT

# Allow web connections
iptables -A LAB-8 -p tcp --dport 80 -j ACCEPT
iptables -A LAB-8 -p tcp --dport 443 -j ACCEPT

# Allow samba connections
iptables -A LAB-8 -p udp --dport 137 -j ACCEPT
iptables -A LAB-8 -p udp --dport 138 -j ACCEPT
iptables -A LAB-8 -p tcp --dport 139 -j ACCEPT
iptables -A LAB-8 -p tcp --dport 445 -j ACCEPT
iptables -A LAB-8 -p udp --dport 445 -j ACCEPT
