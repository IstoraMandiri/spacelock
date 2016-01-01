# spacelock
Raspberry Pi Door Lock System


I found this on Adafruit.

It enables you to backup the OS Sd card of a Raspberry Pi onto an SD card that is plugged into one of the USB slots of the Raspberry Pi

I initially tested it using Raspian Wheezy and it made a good clone of the card that worked when tested.

https://learn.adafruit.com/adafruit-raspberry-pi-lesson-1-preparing-and-sd-card-for-your-raspberry-pi/make-a-backup-image

The Git for the file is here - Use the file from the Git as it seems to work better.

https://github.com/billw2/rpi-clone

Would it be possible to create an automated script that would perodically backup the OS SD card onto the backup USB SD card?

Maybe it would only need to backup Entry/Exit logging and new account creation data as it happens or maybe batch backup data every 24 hours.

In admin access a control could also be created to start a backup manually if required.

