#!/bin/bash
# This function library goes with final.sh script.

TRAP_C()
{
echo "   Please wait for the script to finish!"
}

TRAP_T()
{
echo "   OK, reverting the changes, please wait..."
if_exiv2 REMOVE
if_exiftool REMOVE



}

# Function to install/remove exiv2:
if_exiv2()
{
if [ ${1} == INSTALL ]
  then
    exiv2 &>/dev/null
    if [[ ${?} = 127 ]]
      then
        logger "Installing exiv2 in preparation for running ${0} script."
        echo "Exiv2 was not found on your system; installing..." | tee ~/exiv2.log
        yum -y install exiv2 &>>~/exiv2.log
        if [[ ${?} = 0 ]]
          then
            echo "The package exiv2 was installed successfully!" | tee -a ~/exiv2.log
        fi
      else
        echo "Exiv2 appears to be installed and is working properly, continuing..." | tee -a ~/exiv2.log
    fi
fi
# Removing the exiv2:
if [ ${1} == REMOVE ]
  then
    logger "Removing the exiv2 using the ${0} script."
    echo "Removing the exiv2 package..." | tee -a ~/exiv2.log
    yum -y remove exiv2 &>>~/exiv2.log
    if [[ ${?} = 0 ]]
      then
        echo "The package exiv2 was removed successfully!" | tee -a ~/exiv2.log
    fi
fi
} 2>>~/exiv2.log


# Function to install/remove exiftool:
if_exiftool()
{
if [ ${1} == INSTALL ]
  then
    exiftool ${0} &>/dev/null
    if [[ ${?} = 127 ]]
      then
        logger "Installing exiftool in preparation for running ${0} script."
        echo "ExifTool was not found on your system; installing..." | tee ~/exiftool.log
        # Installing required package perl-ExtUtils-MakeMaker:
        if [[ ! $(rpm -q perl-ExtUtils-MakeMaker) = 0 ]]
          then
            echo "Installing required package perl-ExtUtils-MakeMaker..." | tee ~/perl-ExtUtils.log
            yum -y install perl-ExtUtils-MakeMaker &>>~/perl-ExtUtils.log
        fi
        # Installing exiftool from source: http://www.sno.phy.queensu.ca/~phil/exiftool/
        # The following installs a specific version of Image-ExifTool.
        # If the command fails then verify if program version haven't changed.
        ExifVer=Image-ExifTool-10.20
        TMP1=$(mktemp -d)
        cd ${TMP1}
        echo "Downloading ExivTool installation files..." | tee -a ~/exiftool.log
        wget http://www.sno.phy.queensu.ca/~phil/exiftool/${ExifVer}.tar.gz &>>~/exiftool.log
        echo "Extracting ExivTool installation files..." | tee -a ~/exiftool.log
        gzip -dc ${ExifVer}.tar.gz | tar -xf - &>>~/exiftool.log
        cd ${ExifVer}
        perl Makefile.PL &>>~/exiftool.log
        echo "Performing internal tests before installation (shouldn't take more than 30 sec)..." | tee -a ~/exiftool.log
        make test &>>~/exiftool.log
        if [ ! $? == 0 ]
          then
            echo "The tests were not successful. Please review exiftool.log for errors."
          else
            echo "The tests comleted successfully!"
        fi
        echo "Continuing with ExifTool installation..."
        make install &>>~/exiftool.log
        if [[ ${?} = 0 ]]
          then
            echo "ExifTool was installed successfully!"
        fi
      else
        echo "ExifTool appears to be installed and is working properly, continuing..." | tee -a ~/exiftool.log
    fi
fi
# Removing exiftool:
if [ ${1} == REMOVE ]
  then
    logger "Removing the exiftool using the ${0} script."
    echo "Removing ExifTool..." | tee -a ~/exiftool.log
    UNINSTALL=$(mktemp)
    cd ${TMP1}/${ExifVer}/
    make uninstall | grep -i unlink > ${UNINSTALL}
    . ${UNINSTALL}
    cd ~
    rm -rf ${TMP1}
    rm -f ${UNINSTALL}
fi
} 2>>~/exiftool.log
