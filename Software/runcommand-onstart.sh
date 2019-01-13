#!/bin/sh

#********** Edit these variables specific to your installation ***********
PIXELPATH="/home/pi/pixel/"
#**************************************************************************

pixelexists='ls /dev/ttyACM0'

if $pixelexists | grep -q '/dev/ttyACM0'; then  #let's only go here if we detect PIXEL via a ls /dev/ttyACM0 command
   echo "PIXEL LED Detected..."
   cd $PIXELPATH
   # $3 is passed to us from RetroPi and tells us the name of the rom, we'll use that and map a unique gif to each one we want to call out
   ROMPATH=$3
   echo "message to log" >&2
   echo $ROMPATH >&2

   if [[ $ROMPATH == *"galaga"* ]];then
     echo "galaga match" >&2
     GAMEIMAGE="galaga.gif"
   elif [[ $ROMPATH == *"pacman"* ]];then
     echo "pacman match" >&2
     GAMEIMAGE="pacman.gif"
   elif [[ $ROMPATH == *"btime"* ]];then
     echo "burgertime match" >&2
     GAMEIMAGE="burgertime.gif"
   elif [[ $ROMPATH == *"defender"* ]];then
     echo "defender match" >&2
     GAMEIMAGE="defender.gif"
   elif [[ $ROMPATH == *"zaxxon"* ]];then
     echo "zaxxon match" >&2
     GAMEIMAGE="zaxxon.gif"
   elif [[ $ROMPATH == *"qbert"* ]];then
     echo "qbert match" >&2
     GAMEIMAGE="qbert.gif"
   elif [[ $ROMPATH == *"digdug"* ]];then
     echo "digdug match" >&2
     GAMEIMAGE="digdug.gif"
   elif [[ $ROMPATH == *"robotron"* ]];then
     echo "robotron match" >&2
     GAMEIMAGE="robotron.gif"
   elif [[ $ROMPATH == *"joust"* ]];then
     echo "joust match" >&2
     GAMEIMAGE="joust.gif"
   elif [[ $ROMPATH == *"scrambl"* ]];then
     echo "scramble match" >&2
     GAMEIMAGE="scramble.gif"
   elif [[ $ROMPATH == *"frogger"* ]];then
     echo "frogger match" >&2
     GAMEIMAGE="frogger.gif"
   elif [[ $ROMPATH == *"bosco"* ]];then
     echo "bosonian match" >&2
     GAMEIMAGE="bosconian.gif"
   elif [[ $ROMPATH == *"berzerk"* ]];then
     echo "berzerk match" >&2
     GAMEIMAGE="berzerk.gif"
   elif [[ $ROMPATH == *"gorf"* ]];then
     echo "gorf match" >&2
     GAMEIMAGE="gorf.gif"
   elif [[ $ROMPATH == *"dkong"* ]];then
     echo "donkey kong match" >&2
     GAMEIMAGE="donkeykong.gif"
   elif [[ $ROMPATH == *"jungle"* ]];then
     echo "jungle king match" >&2
     GAMEIMAGE="jungleking.gif"
   elif [[ $ROMPATH == *"mpatrol"* ]];then
     echo "moon patrol match" >&2
     GAMEIMAGE="moonpatrol.gif"
   elif [[ $ROMPATH == *"invader"* ]];then
     echo "space invaders match" >&2
     GAMEIMAGE="spaceinvaders.gif"
   elif [[ $ROMPATH == *"vanguard"* ]];then
     echo "vanguard match" >&2
     GAMEIMAGE="vanguard.gif"
   else
     echo "no game match" >&2
     GAMEIMAGE="cherry.gif"
   fi

   java -jar pixelc.jar --gif=$GAMEIMAGE --write


else echo "PIXEL LED Not Detected"
fi
