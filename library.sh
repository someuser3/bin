#!/bin/bash
# This function library goes with final.sh script.

check_pkg()
{
exec 3>&1
exec 1>>~/${1}.log
${1} 2>&1
if [[ ${?} = 127 ]]
  then
    echo "Please wait, preparing environment..." | tee >&3
    logger "Installing ${1} in preparation for running ${0} script."
    yes | yum install ${1}
  else :
fi
exec 1>&3
exec 3>&-
}
