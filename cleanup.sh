#!/bin/bash

yum -y remove exiv2-libs.x86_64
yum -y remove perl-ExtUtils-MakeMaker
rm -rf /tmp/*
rm -f ~/exiftool.log
rm -f ~/perl-ExtUtils.log
