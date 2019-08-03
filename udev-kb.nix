{}:
''
# Atmel ATMega32U4
SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", MODE:="0666"

# Atmel USBKEY AT90USB1287
SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffb", MODE:="0666"

# Atmel ATMega32U2
SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", MODE:="0666"

# tmk keyboard products     https://github.com/tmk/tmk_keyboard
SUBSYSTEMS=="usb", ATTRS{idVendor}=="feed", MODE:="0666"

# Input Club keyboard bootloader
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1c11", MODE:="0666"

# ModemManager should ignore the following devices
ATTRS{idVendor}=="2a03", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="2341", ENV{ID_MM_DEVICE_IGNORE}="1"

# stm32duino
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", MODE:="0666"

# Generic stm32
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666"
''
