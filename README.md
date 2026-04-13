# Pico 2040 FreeRTOS Boilerplate

Minimal FreeRTOS boilerplate for the Pico (Raspberry Pi Pico 2040) with a single blinky app. **Use the git clone command below**

If you are using WSL or are building to a Wireless Pico, follow the steps at the end. Else, Ignore Steps 5-6

There are no instructions for plain Windows too. Only Mac, Linux and Windows Subsystem for Linux. 

## Why this is minimal (somewhat)

- One app source file: `rp2040-freertos/src/main.c`
- Two board target choices: `pico` and `pico w`

## 1. System-level dependencies (machine setup)

Install these once per laptop/workstation:

- Git
- CMake

Example package install commands:

```bash
# macOS (Homebrew)
brew install git cmake
```

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y git cmake
```

## 2. Project-level dependencies 
Cloning the repo and initilizing the submodules

```bash
git clone https://github.com/Doyle-Squared/rp2040-test5.git
git submodule update --init --recursive
```

Next is dowloading the Pico SDK if you dont already have it. Navigate to your home directory, the one that says just `~/`
Now enter these commands

```bash
mkdir -p ~/pico $$ cd ~/pico
git clone -b master https://github.com/raspberrypi/pico-sdk.git
cd pico-sdk
git submodule update --init
export PICO_SDK_PATH="~/pico/pico-sdk"
```

If your file explorer is empty, click on open folder  in VS Code and locate the folder with the repository name. Any other errors, consult the Internet for now.

## 3. Build steps

From project root

```bash
cd build/ && cmake .. && make
```

Build artifact used for flashing:

- `build/src/rp2040-freertos.uf2`


## 4. Flash plus build steps

macOS/Linux: (literally just this)

```bash
./flash.sh
```

## Project structure

```text
rp2040-freertos/
├── src/
│   ├── CMakeLists.txt
│   ├── FreeRTOSConfig.h
│   └── main.c
├── flash.sh
└── README.md
```

## 5. Using WSL on Windows (If on Linux/MacOS, then ignore)

Open Powershell as administrator

Download usbipd

```text
#Powershell
winget install --interactive --exact dorssel.usbipd-win
```

We now have to bind both the Pico BOOTSEL and Standard modes. This is because the Pico changes its VID:PID when switching between modes
Plug in the Pico in BOOTSEL mode. You should see it appear with RP2 or RP1 in the name

Run these commands below, where "bus_ID" is the usb port your plugged the Pico into. Dont include "", e.g. only 2-3
```text
usbipd bind --busid "bus_ID" --force
usbipd attach --wsl --busid "bus_ID"
```

Navigate back to VS Code and manually build the project with 

```bash
mkdir build && cd build/ && cmake .. && make && cd src/
```

Then flash with

```bash
sudo picotool load -x rp2040-freertos-template.uf2
```

After you flash, your Pico LED should be blinking

Navigate back to Powershell and type the commands below. After running the list command, you should see your Pico as a USB Serial Device (COM6)
and/or the VID of one of the devices should match that of the one when the Pico is in BOOTSEL mode.

```text
usbipd list
usbipd bind --busid "bus_ID" --force
``

Now you can run a new attach command that auto attaches the Pico to WSL
```text
usbipd bind --busid "bus_ID" --auto-attach
```

Now navigate back to VS Code and then the flash.sh file.
Uncomment the lines below "FOR WSL USERS ONLY" and comment out the "picotool" load command above

Make sure to change the VIP:PID addresses to whatever printed in Powershell when you ran the "usbipd list" command since Aidan is using a Pico W for now. 
The addresses are found next to the "lsusb -d" commands and the first one is the VID:PID when the Pico is in standard mode, while the address lower down is when the Pico is in BOOTSEL mode

If all worked smoothly, you should be able to now run the ./flash.sh command whenever you change the code and you want to build + flash. If not, consult your favorite online debugging tool through google

**NOTE:** You must run the usbipd auto attach command every time you close Powershell your powerdown your computer, but you dont need to launch PS in administrator mode anymore. You might have to run the command twice, once in BOOTSel, and another time in standard mode, not too sure though.

## 6. Using another rp2040 like the Pico W

Navigate to the repo root's CMakeLists.txt file and uncomment the `set(PICO_BOARD pico_w)` line and comment out the other set command above

Navigate the the CMakeLists.txt file in the src/ directory and uncomment the `pico_cyw43_arch_none` line

Finally, make your way to the main.c file and uncomment the `##include "pico/cyw43_arch.h"` line. Also uncomment blinky code listed for the Pico W, and comment out the regular Pico code. This is because the LED GPIO is connected differently on the Pico W
