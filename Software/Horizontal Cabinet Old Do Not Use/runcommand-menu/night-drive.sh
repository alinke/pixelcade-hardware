#!/bin/sh

#********** Edit these variables specific to your installation ***********
PIXELPATH="/home/pi/pixel/"
#**************************************************************************

pixelexists='ls /dev/ttyACM0'

if $pixelexists | grep -q '/dev/ttyACM0'; then
   echo "PIXEL LED Detected..."
   cd $PIXELPATH
    java -jar pixelc.jar --gif=0nightdrive.gif --write
fi
