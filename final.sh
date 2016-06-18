#!/bin/bash

. ~/bin/library.sh
trap "TRAP_C" SIGINT
trap "TRAP_T" SIGTERM

# Processing arguments:
while getopts :fhd OPT; do
  case "$OPT" in
    d) set -x;;
    f) FORCE="YES";;
    h) HELP="WANTED";;
    *) echo "Unknown argument detected. Please run ${0##*/} -h for correct usage information."; exit 1;;
  esac
done

# Removing options, keeping additional arguments:
shift $[ $OPTIND - 1 ]

# Processing -h option:
if [ ! -z $HELP ]; then
  echo -e "This script is designed to create a Year/Month/Day structure inside of a DIRECTORY based on \nthe creation date of the media files in the DIRECTORY, and copy/move files accordingly."
  echo "Usage:"
  echo "	${0##*/} DIRECTORY        Creates the Year/Month/Day structure and copies the mediafiles"
  echo "	${0##*/} -f DIRECTORY     Creates the Year/Month/Day structure and moves the mediafiles"
  echo "	${0##*/} -h               Prints this message and exits"
  echo "        ${0##*/} -d               Turns on debugging information"
  echo
  exit
fi

# Checking if input parameter has been supplied and providing help messages if needed:
if [ -z "${1}" ]
  then
    echo "Please provide a directory for script to work on. For usage information run ${0##*/} -h."
    exit 123
  elif [[ (! -d $1) || (! -r $1) ]]
    then
      echo "Unable to open ${1} for reading, exiting..."
      exit 403
fi

# Checking if packages are installed:
echo -e "Checking if all necessary packages are installed. Please wait as this may take up to a minute."
if_exiv2 INSTALL
if_exiftool INSTALL

# Down below is the meat of the script, but it's not there yet... Stay tuned for more! :D







# Testing the remove procedures:
read -p "Do you want to remove the exiv2 now? (y/N)" -n 1 ANS1
if [[ ${ANS1} = [Y/y] ]]
  then
    echo
    if_exiv2 REMOVE
  else
    echo "Skipping..."
fi

read -p "Do you want to remove the exiftool now? (y/N)" -n 1 ANS2
if [[ ${ANS2} = [Y/y] ]]
  then
    echo
    if_exiftool REMOVE
  else
    echo "Nothing to do!"
fi
echo "Done!"
