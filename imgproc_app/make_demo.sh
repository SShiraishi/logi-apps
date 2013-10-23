#!/bin/sh

read -p "What is your board version (RA1, RA2, ...)" BOARD_VERSION

logi_loader ./logipi_camera_${BOARD_VERSION}.bit


DISTRO="$(cat /etc/os-release | grep "^ID=.*" | sed "s,ID=,,")"
echo $DISTRO
if [ "$DISTRO" = "debian" ]; then
apt-get update
apt-get install gcc make v4l-utils libjpeg8-dev
ln -s /usr/include/linux/videodev2.h   /usr/include/linux/videodev.h
elif [ "$DISTRO" = "arch" ]; then
pacman -S --needed gcc make v4l-utils libjpeg-turbo
ln -s /usr/include/libv4l1-videodev.h   /usr/include/linux/videodev.h
else
echo "unknown distro, please manually install gcc, make, v4l-utils, libjpeg-turbo"
fi
cd ../tools/logi-mjpg-streamer/
make -j2
echo "Demo will now start :"
echo "Open a browser and connect to http://<your raspberry ip address>:8080/stream.html"
echo "Press PB2 on logibone to switch between video source (normal, gaussian, sobel, harris)"
echo "Press ctrl-c to end demo"

./launch_streamer.sh 0
