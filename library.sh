#!/bin/bash
# This function library goes with final.sh script.

# Checking if exiv2 is installed and installing if necessary:
if_exiv2()
{
exiv2 &>/dev/null
if [[ ${?} = 127 ]]
  then
    logger "Installing exiv2 in preparation for running ${0} script."
    yum -y install exiv2 &>~/exiv2.log
  else :
fi
}


# Checking if exiftool is installed and installing if necessary:
if_exiftool()
{
exiftool ${0} &>/dev/null
if [[ ${?} = 127 ]]
  then
    logger "Installing exiftool in preparation for running ${0} script."
    yum -y install perl-ExtUtils-MakeMaker &>~/perl-ExtUtils.log
    # Need to confirm the above successed.
    TMP1=$(mktemp -d)
    cd ${TMP1}
    wget http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.20.tar.gz
    gzip -dc Image-ExifTool-10.20.tar.gz | tar -xf -
    cd Image-ExifTool-10.20/
    perl Makefile.PL
    make test
    # Need to check if testing is successfull and quit if necessary.
    make install
    # Need to verify installation exit code
    cd
    rm -rf ${TMP1}
  else :
fi
} &>~/exiftool.log

