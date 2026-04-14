#!/bin/bash

#Shell script by Aidan Doyle, updates to come

GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

BIN_FILE="./rp2040-freertos.uf2"

if [ ! -d "build/" ]; then
    mkdir build
else 
    rm -rf build/
    mkdir build
fi

cd build/
cmake ..
make
cd src/

if [ ! -f "$BIN_FILE" ]; then
  echo "${RED}Firmware binary not found at $BIN_FILE${RESET}"
  exit 1
fi

echo "${CYAN}Flashing...${RESET}"
# picotool load -x rp2040-freertos.uf2 -f

#FOR WSL USERS ONLY. UNCOMMENT CODE BELOW IF USING WSL ON WINDOWS
#Automates flashing if using WSL and running both powershell scripts for Pico BOOTSEL and Standard mode. 
#Device Addresses are for Pico WH, not the regular Pico

if  lsusb -d "2e8a:000a" > /dev/null ; then
    picotool reboot -f -u
fi

until lsusb -d 2e8a:0003; do                        #Standard Mode VID:PID 
echo "${YELLOW}Waiting for Pico in BOOTSEL mode...${RESET}"
sleep 1
done

echo "${GREEN}Device Found!${RESET}"
             
picotool load -x rp2040-freertos.uf2           #BOOTSEL Mode VID:PID
