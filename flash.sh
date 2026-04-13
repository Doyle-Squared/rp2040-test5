#!/bin/bash

#Shell script by Aidan Doyle, updates to come

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
  echo "Firmware binary not found at $BIN_FILE"
  exit 1
fi

echo "Flashing..."
sudo picotool load -x rp2040-freertos.uf2 -f

#FOR WSL USERS ONLY. UNCOMMENT CODE BELOW IF USING WSL ON WINDOWS
#Automates flashing if using WSL and running both powershell scripts for Pico BOOTSEL and Standard mode. 
#Device Addresses are for Pico WH, not the regular Pico
# if  lsusb -d "2e8a:000a" > /dev/null ; then
#     sudo picotool reboot -f -u
# fi

# until lsusb -d 2e8a:0003; do                        #Standard Mode VID:PID 
# echo "Waiting for Pico in BOOTSEL mode..."
# sleep 1
# done
# echo "Device Found!"
# sleep 1
             
# sudo picotool load -x rp2040-freertos.uf2           #BOOTSEL Mode VID:PID
