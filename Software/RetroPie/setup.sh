#!/bin/bash

stretch_os=false
buster_os=false
install_succesful=false
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
white=`tput setaf 7`
reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"

cat << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

echo "${magenta}        INSTALLER FOR RETROPIE      ${white}"
echo ""
echo "${red}IMPORTANT:${white} This script will only work on a Pi 2 or 3X (Pi 3B+ recommended) that is running RetroPie"
echo "Now connect Pixelcade to a free USB port on your Pi (do not use a USB hub)"
echo "Ensure the toggle switch on the Pixelcade board is pointing towards USB and not BT"
echo "DO NOT continue if you have a Pi 4 as this will break RetroPie"

read -p "${magenta}Continue? ${white}" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# let's detect if Pixelcade is connected
if ls /dev/ttyACM0 | grep -q '/dev/ttyACM0'; then
   echo "${yellow}Pixelcade LED Marquee Detected${white}"
else
   echo "${red}Sorry, Pixelcade LED Marquee was not detected, pleasse ensure Pixelcade is USB connected to your Pi and the toggle switch on the Pixelcade board is pointing towards USB, exiting..."
   exit 1
fi

#let's check if retropie is installed
if [[ -f "/opt/retropie/configs/all/autostart.sh" ]]; then
  echo "RetroPie installation detected, continuing..."
else
   echo "${red}RetroPie is not installed, please install RetroPie first"
   exit 1
fi

if cat /proc/device-tree/model | grep -q 'Pi 4'; then
   echo "${red}Sorry this script is not compatible with Raspberry Pi 4, exiting..."
fi

# detect what OS we have
if lsb_release -a | grep -q 'stretch'; then
   echo "${yellow}Linux Stretch Detected${white}"
   stretch_os=true
elif lsb_release -a | grep -q 'buster'; then
   echo "${yellow}Linux Buster Detected${white}"
   buster_os=true
else
   echo "${red}Sorry, neither Linux Stretch or Linux Buster was detected, exiting..."
   exit 1
fi

# we have all the pre-requisites so let's continue
sudo apt-get update
# install java runtime
echo "${yellow}Installing Java...${white}"
sudo apt-get install oracle-java8-jdk
#sudo apt-get install openjdk-11-jre
# this is where pixelcade will live

if [ -d "/home/pi/pixelcade" ]; then
  echo "${yellow}Pixelcade directory also exists...${white}"
  cd /home/pi/pixelcade
else
  echo "${yellow}Creating home directory for Pixelcade...${white}"
  mkdir /home/pi/pixelcade && cd /home/pi/pixelcade
fi

# download pixelweb.jar
echo "${yellow}Downloading the Pixelcade Listener (pixelweb)...${white}"
curl -LO http://pixelcade.org/pi/pixelweb.jar
echo " "
# run pixelcade listener in the background, Pixelcade must be USB connected to the Pi at this point, it will hang here if Pixelcade not USB connected
java -jar pixelweb.jar -b & #run pixelweb in the background
# download and install artwork
echo "${yellow}Now downloading and installing artwork...${white}"
curl -LO http://pixelcade.org/pi/artwork.zip && cp artwork.zip /home/pi/pixelcade && unzip -o artwork.zip

# lets install the correct mod based on the OS
if [ "$stretch_os" = true ] ; then
   curl -LO http://pixelcade.org/pi/esmod-stretch.deb && sudo dpkg -i esmod-stretch.deb
elif [ "$buster_os" = true ]; then
  curl -LO http://pixelcade.org/pi/esmod-buster.deb && sudo dpkg -i esmod-buster.deb
else
    echo "${red}Sorry, neither Linux Stretch or Linux Buster was detected, exiting..."
    exit 1
fi

# let's check if autostart.sh already has pixelcade added and if so, we don't want to add it twice
cd /opt/retropie/configs/all/
if cat autostart.sh | grep -q 'pixelcade'; then
   echo "${yellow}Pixelcade already added to autostart.sh, skipping...${white}"
else
  sudo sed -i '/^emulationstation.*/i cd /home/pi/pixelcade && java -jar pixelweb.jar -b &' autostart.sh
fi

# let's send a test image and see if it displays
cd /home/pi/pixelcade
java -jar pixelcade.jar -m stream -c mame -g 1941
echo " "
while true; do
    read -p "${magenta}Is the 1941 Game Logo Displaying on Pixelcade Now?${white}" yn
    case $yn in
        [Yy]* ) echo "${green}INSTALLATION COMPLETE , please now reboot and then Pixelcade will be controlled by RetroPie${white}" && install_succesful=true; break;;
        [Nn]* ) echo "${red}Sorry, please refer to https://pixelcade.org/download-pi/ for troubleshooting steps" && exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ "$install_succesful" = true ] ; then
  while true; do
      read -p "${magenta}Reboot Now?${white}" yn
      case $yn in
          [Yy]* ) sudo reboot; break;;
          [Nn]* ) echo "${yellow}Please reboot when you get a chance" && exit;;
          * ) echo "Please answer yes or no.";;
      esac
  done
fi
