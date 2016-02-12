#!/bin/bash

# Lab objective:
#
# Create a network configuration shell script called netwiz.sh
# which prompts the user for the following network settings:
#
# IP address
# Netmask
# Nameserver
# Default Gateway
#
# Have your wizard set these parameters in the running config AND
# in the network configuration files. You may want to set the
# parameter to turn off Network Manager interfering with the interface:
# NM_CONTROLLED="no".

# Test an IP address for validity (credit to http://www.linuxjournal.com/content/validating-ip-address-bash-script)
function valid_ip()
{
  local  ip=$1
  local  stat=1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  OIFS=$IFS
  IFS='.'
  ip=($ip)
  IFS=$OIFS
  [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
  && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
  stat=$?
  fi
  return $stat
}

# Ask for and validate an IP address
clear
  echo
  echo "Please enter a valid IP address for eth1:"
  echo
while true
  do
  read TEMPIP
  if valid_ip $TEMPIP; then IPADDRESS=$TEMPIP; break; fi
    echo
    echo "This is not a valid IP address. Please enter a valid IP address:"
    echo
done

# Ask for and validate a Netmask
clear
  echo
  echo "Thanks! Now please enter a valid Netmask for eth1:"
  echo
while true
  do
  read TEMPMASK
  if valid_ip $TEMPMASK; then NETMASK=$TEMPMASK; break; fi
    echo
    echo "This is not a valid Netmask. Please enter a valid Netmask:"
    echo
done

# Ask for and validate Default Gateway
clear
  echo
  echo "Great! Now please enter a valid Default Gateway for eth1:"
  echo
while true
  do
  read TEMPGW
  if valid_ip $TEMPGW; then GATEWAY=$TEMPGW; break; fi
    echo
    echo "This is not a valid Gateway. Please enter a valid Gateway:"
    echo
done

# Ask for and validate a Nameserver
clear
  echo
  echo "Almost done! Now please enter a valid Nameserver for eth1:"
  echo
while true
  do
  read TEMPDNS
  if valid_ip $TEMPDNS; then NAMESERVER=$TEMPDNS; break; fi
    echo
    echo "This is not a valid Nameserver. Please enter a valid Nameserver:"
    echo
done

# Set eth1 IP information for this session
clear
  echo
  echo "At this time we are ready to set eth1 to the following:"
  echo
  echo "IP Address: $IPADDRESS"
  echo "Netmask: $NETMASK"
  echo "Default Gateway: $GATEWAY"
  echo "Nameserver: $NAMESERVER"
  echo
read -r -p "Apply the above configuration to eth1 for this session? [y/N] " response
case $response in
  ([yY][eE][sS]|[yY])
  # Set config on the eth1
  ifconfig eth1 down
  ifconfig eth1 $IPADDRESS netmask $NETMASK up
  if [ $? -eq 0 ]
    then
      echo
      echo "Successfully saved configuration for this session."
      echo
    else
      echo 
      echo "**********************ERROR**********************"
      echo "Could not apply the changes... Is eth1 conencted to the computer at this moment?" >&2
      echo "**********************ERROR**********************"
      echo
  fi
  ;;
  *)
    echo
    echo "Skipping applying the settings to current session."
    echo
  ;;
esac

# Validate if there is a current conf file for eth1
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth1 ]
  then
    echo
    echo
    echo
    echo "It appears that the currently eth1 configuration file is set to the following:"
    echo
    echo "**************Beginning of the file**************"
    cat /etc/sysconfig/network-scripts/ifcfg-eth1
    echo "*****************End of the file*****************"
    echo
    echo
    echo "Proposed configuration for eth1 as follows:"
    echo
    echo "**************Beginning of the file**************"
    echo "NAME=\"eth1\""
    echo "NM_CONTROLLED=no"
    echo "ONBOOT=yes"
    echo "TYPE=Ethernet"
    echo "IP Address: $IPADDRESS"
    echo "Netmask: $NETMASK"
    echo "Default Gateway: $GATEWAY"
    echo "DNS1: $NAMESERVER"
    echo "*****************End of the file*****************"
    echo
fi

# Set eth1 IP informaiton in config files
echo
read -r -p "Would you like to save the above configuration for eth1 to persist between reboots? [y/N] " response
case $response in
  ([yY][eE][sS]|[yY])
  # Write collected information into eth1 config file
  echo NAME=\"eth1\" > /etc/sysconfig/network-scripts/ifcfg-eth1
  echo NM_CONTROLLED=no >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo TYPE=Ethernet >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo IPADDR=$IPADDRESS >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo NETMASK=$NETMASK >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo GATEWAY=$GATEWAY >> /etc/sysconfig/network-scripts/ifcfg-eth1
  echo DNS1=$NAMESERVER >> /etc/sysconfig/network-scripts/ifcfg-eth1
  if [[ $(cat /etc/resolv.conf | awk '{print ($2 == "$NAMESERVER") ? "OLD" : "NEW"}' | uniq | wc -l) = 1 ]]
    then
      echo "nameserver $NAMESERVER" >> /etc/resolv.conf
  fi
    echo
    echo "Done!"
    echo
  ;;
  *)
    echo
    echo "Exiting without saving the configuration."
    echo
  ;;
esac

