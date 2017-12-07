#!/bin/sh


umount /dev/mmcblk0p3
echo /dev/mmcblk0p3  > /sys/class/android_usb/f_mass_storage/lun/file

echo 0 > /sys/class/android_usb/android0/enable

echo 18d1 > /sys/class/android_usb/android0/idVendor

echo 4e13 > /sys/class/android_usb/android0/idProduct

echo mass_storage > /sys/class/android_usb/android0/functions

echo 1 > /sys/class/android_usb/android0/enable
echo 1 > /sys/devices/15400000.usb/15400000.dwc3/b_sess 
