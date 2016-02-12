#!/bin/bash

# The reason for this script's existence is to safely modify
# iptables rules and have a way out in case things go south.

# Add iptables rules to the below script. NOTE: I created a
# new chain called LAB-8 and am adding new iptables rules to it.
/root/projects/bin/firewall.sh

# Wait 30 seconds to see if your firewall rules make you to
# lose connection. May be a good idea to have a separate ssh
# session in place to confirm things are going well.
sleep 30

# Clear all iptables rules and remove an empty LAB-8 chain:
iptables -F
iptables -X LAB-8
