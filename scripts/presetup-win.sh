#!/bin/bash

DOCKER_VERSION=1.9.1
DOCKER_COMPOSE_VERSION=1.5.2

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

# For testing
if [ ! $B2D_BRANCH == "" ]; then
	echo-red "[b2d-setup] testing mode: environment = ${B2D_BRANCH}"
else
	B2D_BRANCH='master'
fi

# Install prerequisites via choco (virtualbox and vagrant)
echo-green "Installing virtualbox and vagrant via choco..."
curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.cmd -o $WINDIR/Temp/presetup-win.cmd
curl -sSL https://raw.githubusercontent.com/blinkreaction/boot2docker-vagrant/${B2D_BRANCH}/scripts/presetup-win.vbs -o $WINDIR/Temp/presetup-win.vbs
echo-yellow "Setup needs administrator privileges to contiue..."
cscript $WINDIR/Temp/presetup-win.vbs

# Install Docker
echo-green "Installing docker cli v${DOCKER_VERSION}..."
curl -sSL https://get.docker.com/builds/Windows/i386/docker-$DOCKER_VERSION.exe -o /usr/local/bin/docker
chmod +x /usr/local/bin/docker

# Install Docker Compose
echo-green "Installing docker-compose v${DOCKER_COMPOSE_VERSION}..."
curl -sSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Windows-x86_64.exe > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install winpty (workaround for "cannot enable tty mode on non tty input")
echo-green "Installing winpty..."
curl -sSL https://github.com/rprichard/winpty/releases/download/0.2.1/winpty-0.2.1-cygwin-2.3.0-ia32.tar.gz -o winpty.tar.gz
tar zxf winpty.tar.gz
cp -R winpty-0.2.1-cygwin-2.3.0-ia32/bin $CYGWIN_HOME
rm -f winpty.tar.gz
rm -rf winpty-0.2.1-cygwin-2.3.0-ia32

# Git settings
echo-green "Adjusting git defaults..."
git config --global core.autocrlf input
git config --system core.longpaths true
