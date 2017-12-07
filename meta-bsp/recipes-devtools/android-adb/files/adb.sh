#!/bin/bash

#starting adb daemon
adbd &

#device setting
echo 1 > /sys/devices/15400000.usb/15400000.dwc3/id
echo 1 > /sys/devices/15400000.usb/15400000.dwc3/b_sess

#for USB3.0 port as adb connection (when we need to set forcely)
#echo 0 > /sys/devices/15510000.usb/15510000.dwc3/id

#for adb
echo 0 > /sys/class/android_usb/android0/enable
echo 4e11 > /sys/class/android_usb/android0/idProduct
echo adb > /sys/class/android_usb/android0/functions
echo 1 > /sys/class/android_usb/android0/enable
chmod 777 /dev/android_adb 
mkdir -p /system/bin
cp /bin/sh /system/bin
echo "ADB Inital Done.."


