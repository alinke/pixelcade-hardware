#!/bin/sh

#TO DO see if streaming works and killing the prior process
#v3.4
# *************** Defaults you can change in this section if you like *********************
# Change this if you have the pixel directory in a different location
PIXELPATH="/home/pi/pixel/"
PIPATH="/dev/ttyACM0"
MAMECSV="mame.csv"  # .csv file that maps rom name to game name
# Default LED Matrix Resolution, supported are 32x16, 32x32, 64x32, 64x16, 128x32, 64x64
LEDRESOLUTION="64x32"
#Default LED Marquee gifs by platform
MAMEDEFAULT="default-mame.gif"

3DODEFAULT="default-3do.gif"
AMSTRADCPCDEFAULT="default-amstradcpc.gif"
APPLE2DEFAULT="default-apple2.gif"
ATARI800DEFAULT="default-atari800.gif"
ATARI2600DEFAULT="default-atari2600.gif"
ATARI5200DEFAULT="default-atari5200.gif"
ATARI7800DEFAULT="default-atari7800.gif"
ATARILYNXDEFAULT="default-atarilynx.gif"
C64DEFAULT="default-c64.gif"
COLECODEFAULT="default-coleco.gif"
DAPHNEDEFAULT="default-daphne.gif"
DREAMCASTDEFAULT="default-dreamcast.gif"
FBADEFAULT="default-fba.gif"
FDSDEFAULT="default-fds.gif"
GBDEFAULT="default-gb.gif"
GBADEFAULT="default-gba.gif"
GBCDEFAULT="default-gbc.gif"
GAMEGEARDEFAULT="default-gamegear.gif"
GENESISDEFAULT="default-genesis.gif"
GAMEGEARDEFAULT="default-gamegear.gif"
INTELLIVISIONDEFAULT="default-intellivision.gif"
MASTERSYSTEMDEFAULT="default-mastersystem.gif"
MACINTOSHDEFAULT="default-macintosh.gif"
MEGADRIVEDEFAULT="default-megadrive.gif"
MSXDEFAULT="default-msx.gif"
NDSDEFAULT="default-nds.gif"
NEOGEODEFAULT="default-neogeo.gif"
NGPCDEFAULT="default-ngpc.gif"
NGPDEFAULT="default-ngp.gif"
N64DEFAULT="default-n64.gif"
NESDEFAULT="default-nes.gif"
PCDEFAULT="default-pc.gif"
PSXDEFAULT="default-psx.gif"
PSPDEFAULT="default-psp.gif"
SATURNDEFAULT="default-saturn.gif"
SEGA32XDEFAULT="default-sega32x.gif"
SEGACDDEFAULT="default-segacd.gif"
SG1000DEFAULT="default-sg-1000.gif"
SNESDEFAULT="default-snes.gif"
PCENGINEDEFAULT="default-pcengine.gif"
ZXSPECTRUMDEFAULT="default-zxspectrum.gif"
WONDERSWANDEFAULT="default-wonderswan.gif"
WONDERSWANCOLORDEFAULT="default-wonderswancolor.gif"
VECTREXDEFAULT="default-vectrex.gif"
VIRTUALBOYDEFAULT="default-virtualboy.gif"
ZMACHINEDEFAULT="default-zmachine.gif"

#*******************************************************************************************
GAMEIMAGE=MAMEDEFAULT #set this as the default and then will change it based on what game / platform is launched
USERMESSAGE=""

pixelexists="ls $PIPATH"

if $pixelexists | grep -q '/dev/ttyACM0'; then  #let's only go here if we detect PIXEL via a ls /dev/ttyACM0 command
   #echo "*** PIXEL LED Marquee ***"

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

   if [[ $PLATFORM == "mame-libretro" ]] || [[ $PLATFORM == "mame-mame4all" ]] || [[ $PLATFORM == "arcade" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       if [[ -f "$MAMECSV" ]]; then
         while IFS=, read -r romname title year manufacturer rpi2	rpi3	bios	notes
         do
             if [[ $romname = $GAMEFILENAME ]];then
               USERMESSAGE="Writing LED Marquee for $title..."
               #echo "Writing LED Marquee for $title..."
             fi
         done < $MAMECSV
       else
           echo "file $MAMECSV does not exist"
       fi
    else
       if [[ -f $MAMEDEFAULT ]]; then
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         #echo "Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $NGPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
       fi
    fi
   fi


   if [[ $PLATFORM == "3do" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $3DODEFAULT ]]; then #a generic marquee exists for this platform
         GAMEIMAGE=$3DODEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT  # no platform marquee exists so we'll use the mame default
         echo "File $3DODEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "apple2" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $APPLE2DEFAULT ]]; then
         GAMEIMAGE=$APPLE2DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $APPLE2DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

    if [[ $PLATFORM == "amstradcpc" ]];then
      echo "Entered ${PLATFORM} If Statement" >&2
     if [[ -f "$MARQUEEGIF" ]]; then
        GAMEIMAGE=$MARQUEEGIF
        echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
        USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
     else
        if [[ -f $AMSTRADCPCDEFAULT ]]; then
          GAMEIMAGE=$AMSTRADCPCDEFAULT
          echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
           USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
        else
          GAMEIMAGE=$MAMEDEFAULT
          echo "File $AMSTRADCPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
        fi
      fi
    fi

    if [[ $PLATFORM == "atari800" ]];then
      echo "Entered ${PLATFORM} If Statement" >&2
     if [[ -f "$MARQUEEGIF" ]]; then
        GAMEIMAGE=$MARQUEEGIF
        echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
        USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
     else
        if [[ -f $ATARI800DEFAULT ]]; then
          GAMEIMAGE=$ATARI800DEFAULT
          echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
        else
          GAMEIMAGE=$MAMEDEFAULT
          echo "File $ATARI800DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
        fi
     fi
    fi

    if [[ $PLATFORM == "atari2600" ]];then
      echo "Entered ${PLATFORM} If Statement" >&2
     if [[ -f "$MARQUEEGIF" ]]; then
        GAMEIMAGE=$MARQUEEGIF
        echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
        USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
     else
        if [[ -f $ATARI2600DEFAULT ]]; then
          GAMEIMAGE=$ATARI2600DEFAULT
          echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
        else
          GAMEIMAGE=$MAMEDEFAULT
          echo "File $ATARI2600DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
        fi
     fi
    fi

   if [[ $PLATFORM == "atari5200" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $ATARI5200DEFAULT ]]; then
         GAMEIMAGE=$ATARI5200DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARI5200DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
    fi
   fi

   if [[ $PLATFORM == "atari7800" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $ATARI7800DEFAULT ]]; then
         GAMEIMAGE=$ATARI7800DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARI7800DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
    fi
   fi

   if [[ $PLATFORM == "atarilynx" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $ATARILYNXDEFAULT ]]; then
         GAMEIMAGE=$ATARILYNXDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $ATARILYNXDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
    fi
   fi

   if [[ $PLATFORM == "c64" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $C64DEFAULT ]]; then
         GAMEIMAGE=$C64DEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $C64DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
    fi
   fi

   if [[ $PLATFORM == "coleco" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $COLECODEFAULT ]]; then
         GAMEIMAGE=$COLECODEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $COLECODEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
    fi
   fi

   if [[ $PLATFORM == "daphne" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $DAPHNEDEFAULT ]]; then
         GAMEIMAGE=$DAPHNEDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $DAPHNEDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
          USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "dreamcast" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $DREAMCASTDEFAULT ]]; then
         GAMEIMAGE=$DREAMCASTDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $DREAMCASTDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "fba" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $FBADEFAULT ]]; then
         GAMEIMAGE=$FBADEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $FBADEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "fds" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $FDSDEFAULT ]]; then
         GAMEIMAGE=$FDSDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $FDSDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "gb" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GBDEFAULT ]]; then
         GAMEIMAGE=$GBDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GBDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "gba" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GBADEFAULT ]]; then
         GAMEIMAGE=$GBADEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GBADEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "gbc" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GBCDEFAULT ]]; then
         GAMEIMAGE=$GBCDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GBCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "gamegear" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GAMEGEARDEFAULT ]]; then
         GAMEIMAGE=$GAMEGEARDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GAMEGEARDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "genesis" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GENESISDEFAULT ]]; then
         GAMEIMAGE=$GENESISDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GENESISDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "gamegear" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $GAMEGEARDEFAULT ]]; then
         GAMEIMAGE=$GAMEGEARDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $GAMEGEARDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "intellivision" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $INTELLIVISIONDEFAULT ]]; then
         GAMEIMAGE=$INTELLIVISIONDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $INTELLIVISIONDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "macintosh" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $MACINTOSHDEFAULT ]]; then
         GAMEIMAGE=$MACINTOSHDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $MACINTOSHDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi


   if [[ $PLATFORM == "mastersystem" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $MASTERSYSTEMDEFAULT ]]; then
         GAMEIMAGE=$MASTERSYSTEMDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $MASTERSYSTEMDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "megadrive" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $MEGADRIVEDEFAULT ]]; then
         GAMEIMAGE=$MEGADRIVEDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $MEGADRIVEDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "msx" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $MSXDEFAULT ]]; then
         GAMEIMAGE=$MSXDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $MSXDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "nds" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $NDSDEFAULT ]]; then
         GAMEIMAGE=$NDSDEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $NDSDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

   if [[ $PLATFORM == "neogeo" ]];then
     echo "Entered ${PLATFORM} If Statement" >&2
    if [[ -f "$MARQUEEGIF" ]]; then
       GAMEIMAGE=$MARQUEEGIF
       echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
       USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
    else
       if [[ -f $NEOGEODEFAULT ]]; then
         GAMEIMAGE=$NEOGEODEFAULT
         echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
       else
         GAMEIMAGE=$MAMEDEFAULT
         echo "File $NEOGEODEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
         USERMESSAGE="Writing Generic LED Marquee..."
       fi
     fi
   fi

  if [[ $PLATFORM == "ngpc" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $NGPCDEFAULT ]]; then
        GAMEIMAGE=$NGPCDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $NGPCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "ngp" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $NGPDEFAULT ]]; then
        GAMEIMAGE=$NGPDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $NGPDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "n64" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $N64DEFAULT ]]; then
        GAMEIMAGE=$N64DEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $N64DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "nes" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $NESDEFAULT ]]; then
        GAMEIMAGE=$NESDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $NESDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "pc" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $PCDEFAULT ]]; then
        GAMEIMAGE=$PCDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $PCDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "psx" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $PSXDEFAULT ]]; then
        GAMEIMAGE=$PSXDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $PSXDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "psp" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $PSPDEFAULT ]]; then
        GAMEIMAGE=$PSPDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $PSPDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "saturn" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $SATURNDEFAULT ]]; then
        GAMEIMAGE=$SATURNDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $SATURNDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi


  if [[ $PLATFORM == "sega32x" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $SEGA32XDEFAULT ]]; then
        GAMEIMAGE=$SEGA32XDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $SEGA32XDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "segacd" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $SEGACDDEFAULT ]]; then
        GAMEIMAGE=$SEGACDDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $SEGACDDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "sg-1000" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $SG1000DEFAULT ]]; then
        GAMEIMAGE=$SG1000DEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $SG1000DEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "snes" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $SNESDEFAULT ]]; then
        GAMEIMAGE=$SNESDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $SNESDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "pcengine" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $PCENGINEDEFAULT ]]; then
        GAMEIMAGE=$PCENGINEDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $PCENGINEDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "zxspectrum" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $ZXSPECTRUMDEFAULT ]]; then
        GAMEIMAGE=$ZXSPECTRUMDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $ZXSPECTRUMDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "wonderswan" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $WONDERSWANDEFAULT ]]; then
        GAMEIMAGE=$WONDERSWANDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $WONDERSWANDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "wonderswancolor" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $WONDERSWANCOLORDEFAULT ]]; then
        GAMEIMAGE=$WONDERSWANCOLORDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $WONDERSWANCOLORDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "vectrex" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $VECTREXDEFAULT ]]; then
        GAMEIMAGE=$VECTREXDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $VECTREXDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "virtualboy" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $VIRTUALBOYDEFAULT ]]; then
        GAMEIMAGE=$VIRTUALBOYDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $VIRTUALBOYDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi

  if [[ $PLATFORM == "zmachine" ]];then
    echo "Entered ${PLATFORM} If Statement" >&2
   if [[ -f "$MARQUEEGIF" ]]; then
      GAMEIMAGE=$MARQUEEGIF
      echo "File $MARQUEEGIF exists so we'll write it to the LED marquee" >&2
      USERMESSAGE="Writing LED Marquee for ${GAMEFILENAME}..."
   else
      if [[ -f $ZMACHINEDEFAULT ]]; then
        GAMEIMAGE=$ZMACHINEDEFAULT
        echo "File $MARQUEEGIF DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee for the ${PLATFORM} Emulator..."
      else
        GAMEIMAGE=$MAMEDEFAULT
        echo "File $ZMACHINEDEFAULT DOES NOT exist, defaulting to generic LED marquee: ${GAMEIMAGE}" >&2
        USERMESSAGE="Writing Generic LED Marquee..."
      fi
   fi
  fi


  if [[ -f "pixel-logo.txt" ]]; then  #some ascii art for logo is in this file
    cat "pixel-logo.txt"
    echo " "
  else
     echo "*** PIXEL LED Marquee ***"
  fi

   #now we're done, let's call the code to write the LED marquee image
   # but let's first check if the current gif is the same as the newly selected one and if yes, we'll skip the write to save time

   # get the md5 of the last written LED GIF from last-marquee.txt, think of md5 as file checksum, basically a way to tell if the file is different or same
   if [[ -f "last-marquee.txt" ]]; then
     md5old=$(head -n 1 "last-marquee.txt")  #read the first line
   else
     md5old="9999999999999999"               #file doesn't exist so give the md5old some fake md5 that won't match
   fi

   #now let's get the MD5 of the new LED marquee GIF and see if they are the same
   md5new=($(md5sum ${GAMEIMAGE}))
   echo $md5new > last-marquee.txt  #write to a text file so we can check next time, and note we are overwriting here, not appending

   if [[ "$md5old" == "$md5new" ]]; then  #now check if they are the same
       echo "LED Marquee hasn't changed so not writing again..."
   else
       echo $USERMESSAGE
       echo >&2
       java -jar "${PIXELPATH}pixelc.jar" --gif="$GAMEIMAGE" --${LEDRESOLUTION} --write --silent #this line does the actual LED write /TODO check later if stream with & works instead of write to save time. If that works, then would need to find a way to kill the current process but downside here is that the Pi is burning CPU cycles whereas the write moves the compute over to the PIXEL controller so may be best to leave as is
        #java -jar "${PIXELPATH}pixelc.jar" --path="$PIXELPATH" --gif="$GAMEIMAGE" --${LEDRESOLUTION} --write  #without silient you'll see more output messages on screen which is good for troubleshooting
   fi

else echo "PIXEL LED Marquee Not Detected" >&2
fi
