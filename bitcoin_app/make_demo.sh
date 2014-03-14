#!/bin/sh

read -p "What is your board version (RA1, RA2, RA3)" BOARD_VERSION

sudo logi_loader ./logipi_mining_${BOARD_VERSION}.bit

DISTRO="$(cat /etc/os-release | grep "ID_LIKE=.*" | sed "s,ID_LIKE=,,")"
echo $DISTRO

if [ -f .done ]
then

if [ "$DISTRO" = "arch" ]; then
PYTHON=python2
else
PYTHON=python
fi

$PYTHON logipi.py
exit
fi


if [ "$DISTRO" = "debian" ]; then
sudo apt-get update
sudo apt-get install python-dev
PYTHON=python
elif [ "$DISTRO" = "arch" ]; then
pacman -S --needed python2
PYTHON=python2
else
echo "unknown distro, please manually install gcc, make, v4l-utils, libjpeg-turbo"
PYTHON=python
fi

git clone https://github.com/lthiery/SPI-Py.git spi_lib
cd spi_lib
$PYTHON setup.py build
$PYTHON setup.py install
cd ..

echo "wait for the following script to end"
echo "result should be : nonce :7a33330e "
echo "1) Create an account on mining pool (tested on btcguild and bitlc)"
echo "2) Configure a worker on the pool website"
echo "3) Fill config.py with your worker configuration"
echo "4) Launch python mark1_rpi_miner.py and wait to get rich ..."
echo "INFO: the hashrate (~1.8MHash/s) is intentionnaly limited to prevent the FPGA from overheating."
echo "Because of the low hashrate (compared to bigger FPGA or ASIC), expect to wait some time before getting a valid share ..."
$PYTHON logipi.py
