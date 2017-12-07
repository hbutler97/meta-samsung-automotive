#!/bin/bash
#Jongseok,Park (js0526.park@samsung.com)

mkdir -p /run/user/root
export XDG_RUNTIME_DIR=/run/user/root
weston-simple-egl &
weston-subsurfaces &
gst-launch-1.0 filesrc location="/usr/share/exynos-video-demo/r8.mp4" ! qtdemux ! h264parse ! omxh264dec ! glimagesink &
gst-launch-1.0 --gst-debug-level=1 v4l2src device=/dev/video200 ! 'video/x-raw, format=BGRx, width=1920, height=1080,  framerate=30/1' ! glimagesink sync=false &

