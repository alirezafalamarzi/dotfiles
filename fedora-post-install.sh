# Author: Alireza Falamarzi
# Created: August 8, 2025

#!/bin/bash


############################################
#                                          #
# __      ____ _ _ __ _ __ (_)_ __   __ _  #
# \ \ /\ / / _` | '__| '_ \| | '_ \ / _` | #
#  \ V  V / (_| | |  | | | | | | | | (_| | #
#   \_/\_/ \__,_|_|  |_| |_|_|_| |_|\__, | #
#                                   |___/  #
############################################
#                                          #
#  This script should be run with sudo or  #
#  as root. It is only meant for a freshly #
#  installed Fedora Linux OS.              #
#                                          #
############################################

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo"
   exit 1
fi

PROGRESS_FILE = ~/.fedora_install_progress
PROGRESS = "initialization"
echo $PROGRESS > $PROGRESS_FILE


# Check if we are using KDE or Gnome:
# (Just for Gtk vs Qt app preferences)

DESKTOP_ENV = "unknown"
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
	DESKTOP_ENV = "gnome"
elif [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
	DESKTOP_ENV = "kde"
fi


# Updating the system
function system_update() {
	echo "This system has an NVIDIA gpu."
	echo "Updating packages..."
	sleep 5
	dnf update --refresh -y
	sleep 5
	echo "updated" > $PROGRESS_FILE
	echo "Updating is done."
	echo "The computer will reboot in 10 minutes."
	echo "Please run the script again after the reboot to continue."
	sleep $((10 * 60))
	shutdown -r now
}

# Installing various packages I always need
function install_packages() {

	# Add RPM-Fusion Free and Non-Free:
	dnf install https://mirrors.rpmfusion.org/free/fedora \
		/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
		https://mirrors.rpmfusion.org/nonfree/fedora/ \
		rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	
	# Add VSCode Repository from Microsoft:
	rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\n \
	name=Visual Studio Code\n \
	baseurl=https://packages.microsoft.com/yumrepos/vscode\n \
	enabled=1\n \
	autorefresh=1\n \
	type=rpm-md\n \
	gpgcheck=1\n \
	gpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
	| tee /etc/yum.repos.d/vscode.repo > /dev/null
	

	# Installing packages
	
	if [[ $DESKTOP_ENV == "kde" ]]; then
		# Internet
		dnf install google-chrome-stable
		# Media
		dnf install \
			vlc \
			obs-studio \
			kdenlive \
			kcolorchooser
		# Development
		dnf install \
			@development-tools \
			code \
			VirtualBox \
			cascadia-mono-fonts \
			qt6-*-devel \
			java-latest-openjdk-devel \
			code \
			kate \
			nodejs \
			golang
	elif [[ $DESKTOP_ENV == "gnome" ]]; then
		# Internet
		dnf install google-chrome-stable
		# Media
		dnf install \
			obs-studio \
			gimp \
		# Development
		dnf install \
			@development-tools
			code \
			VirtualBox \
			cascadia-mono-fonts \
			java-latest-openjdk-devel \
			code \
			nodejs \
			golang \
			geany \
			geany-plugin-* \
			geany-themes
	fi

	# flatpaks
	flatpak install -y flathub \
		com.discordapp.Discord \
		com.brave.Browser

	echo "Installing packages done."
	echo "The computer will reboot after 5 minutes."
	echo "packages" > $PROGRESS_FILE
	sleep $((5 * 60))
	shutdown -r now
}


# This function installs NVIDIA XORG drivers
function nvidia() {
	if lspci | grep -i 'nvidia' &>/dev/null; then
		echo "This system has an NVIDIA gpu."
		echo "Updating..."
		dnf upgrade --refresh
		echo "Installing nvidia drivers..."
		dnf install \
			gcc \
			kernel-headers \
			kernel-devel \
			akmod-nvidia \
			xorg-x11-drv-nvidia \
			xorg-x11-drv-nvidia-libs \
			xorg-x11-drv-nvidia-libs.i686
	
	
		echo "Installation done."
		echo "Waiting for 10 minutes for the system to load all modules."
		sleep $((10 * 60))
		sudo akmods --force
		sudo dracut --force
		echo "Modules loaded."
		echo "The computer will reboot after 5 minutes."
		echo "Please run the script again after the reboot."
		echo "nvidia" > $PROGRESS_FILE
		sleep $((3 * 60))
		shutdown -r now
	else
		echo "This system does not have an NVIDIA gpu."
		echo "No gpu drivers need to be installed."
	fi
}

function all_done() {
	echo "All done. Removing temp files."
	rm $PROGRESS_FILE
}


PROGRESS = $(cat $PROGRESS_FILE)

if [[ $PROGRESS == "initialization" ]]; then
	system_update()
elif [[ $PROGRESS == "updated" ]]; then
	nvidia()
elif [[ $PROGRESS == "nvidia" ]]; then
	install_packages()
elif [[ $PROGRESS == "packages"]]; then
	all_done()
fi
