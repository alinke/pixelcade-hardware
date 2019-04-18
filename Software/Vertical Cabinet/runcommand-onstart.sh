#!/bin/sh

#TO DO see if streaming works and killing the prior process

# *************** Defaults you can change in this section if you like *********************
# Change this if you have the pixel directory in a different location
PIXELPATH="/home/pi/pixel/"
# Default LED Matrix Resolution, supported are 32x16, 32x32, 64x32, 64x16, 128x32, 64x64
LEDRESOLUTION="64x32"
#Default LED Marquee gifs by platform
MAMEDEFAULT="default-mame.gif"
AMSTRADCPCDEFAULT="default-amstradcpc.gif"
ATARI2600DEFAULT="default-atari2600.gif"
ATARI5200DEFAULT="default-atari5200.gif"
ATARI7800DEFAULT="default-atari7800.gif"
ATARILYNXDEFAULT="default-atarilynx.gif"
C64DEFAULT="default-c64.gif"
COLECODEFAULT="default-coleco.gif"
NGPCDEFAULT="default-ngpc.gif"
#*******************************************************************************************
GAMEIMAGE=MAMEDEFAULT #set this as the default and then will change it based on what game / platform is launched

pixelexists='ls /dev/ttyACM0'

if $pixelexists | grep -q '/dev/ttyACM0'; then  #let's only go here if we detect PIXEL via a ls /dev/ttyACM0 command
   echo "PIXEL LED Marquee Detected..."
   cd $PIXELPATH
   # $1 is passed to us from RetroPi and tells us the arcade platform, $3 is the rom path
   PLATFORM=$1
   ROMPATH=$3
   # Let's extract just the filename and then we can see if that matches an LED gif file on the Pi
   GAMEFILENAME=$(basename -- "$ROMPATH")
   #extension="${GAMEFILENAME##*.}"
   GAMEFILENAME="${GAMEFILENAME%.*}"
   #MARQUEEGIF="${GAMEFILENAME}.gif"
   echo "**** PIXEL LED MARQUEE LOG ****" >&2
   #Note the log (all lines with >&2) is written here on your Pi /root/dev/shm/runcommand.log
   echo "Selected Platform: ${PLATFORM}" >&2
   echo "Selected Game Full Path: ${ROMPATH}" >&2
   echo "Selected Game Name Only: ${GAMEFILENAME}" >&2
   #echo "Target LED GIF: ${PIXELPATH}${PLATFORM}/${MARQUEEGIF}" >&2  # example /home/pi/pixel/atari2600/pacman.gif
   #echo "Target LED GIF: ${PIXELPATH}${PLATFORM}/${MARQUEEGIF}" >&2  # example /home/pi/pixel/atari2600/pacman.gif

   MARQUEEGIF="${PIXELPATH}${PLATFORM}/${GAMEFILENAME}.gif"  #this is using absolute path
   #MARQUEEGIF="${PIXELPATH}${GAMEFILENAME}.gif"

   echo "Target LED GIF: ${MARQUEEGIF}" >&2

    if [[ $PLATFORM == "amstradcpc" ]];then
      echo "Entered ${PLATFORM} If Statement" >&2
     if [[ -f "$MARQUEEGIF" ]]; then
        GAMEIMAGE=$MARQUEEGIF
        echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
     else
        if [[ -f $AMSTRADCPCDEFAULT ]]; then
          GAMEIMAGE=$AMSTRADCPCDEFAULT
          echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        else
          GAMEIMAGE=$MAMEDEFAULT
          echo "File $AMSTRADCPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        fi
      fi
    fi

    if [[ $PLATFORM == "atari2600" ]];then
      echo "Entered ${PLATFORM} If Statement" >&2
     if [[ -f "$MARQUEEGIF" ]]; then
        GAMEIMAGE=$MARQUEEGIF
        echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
     else
        if [[ -f $ATARI2600DEFAULT ]]; then
          GAMEIMAGE=$ATARI2600DEFAULT
          echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        else
          GAMEIMAGE=$MAMEDEFAULT
          echo "File $ATARI2600DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        fi
     fi
    fi

   if [[ $PLATFORM == "atari5200" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
    else
       if [[ -f $ATARI5200DEFAULT ]]; then
         GAMEIMAGE=$ATARI5200DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARI5200DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi

   if [[ $PLATFORM == "atari7800" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
    else
       if [[ -f $ATARI7800DEFAULT ]]; then
         GAMEIMAGE=$ATARI7800DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARI7800DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi

   if [[ $PLATFORM == "atarilynx" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
    else
       if [[ -f $ATARILYNXDEFAULT ]]; then
         GAMEIMAGE=$ATARILYNXDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARILYNXDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi

   if [[ $PLATFORM == "c64" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
    else
       if [[ -f $C64DEFAULT ]]; then
         GAMEIMAGE=$C64DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $C64DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi

   if [[ $PLATFORM == "coleco" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
    else
       if [[ -f $COLECODEFAULT ]]; then
         GAMEIMAGE=$COLECODEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $COLECODEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi

  if [[ $PLATFORM == "mame-libretro" ]] || [[ $PLATFORM == "mame-mame4all" ]] || [[ $PLATFORM == "arcade" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
   else
      if [[ -f $MAMEDEFAULT ]]; then
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $NGPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
      fi
   fi
  fi

  if [[ $PLATFORM == "ngpc" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
   else
      if [[ -f $NGPCDEFAULT ]]; then
        GAMEIMAGE=$NGPCDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $NGPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
      fi
   fi
  fi


   #now we're done, let's call the code to write the LED marquee image
   echo >&2
   java -jar "${PIXELPATH}pixelc.jar" --path="$PIXELPATH" --gif="$GAMEIMAGE" --${LEDRESOLUTION} --write


else echo "PIXEL LED Marquee Not Detected"
fi
