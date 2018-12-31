#!/bin/bash
#: Title	:	upgrade_script
#: Date		:	7-19-2019
#: Author	:	"Alex Pujols" <alex.pujols@gmail.com>
#: Version	:	3.0
#: Description  :	Upgrade script for Slackware custom kernels
#: Options	:	None

########################################################################
# Read in actual kernel image so that we can apply to customize script #
########################################################################

# Start kernel version entry                  
printf "What is the kernel version you would like to build for? \n"
read kernel_name
if [ -z "$kernel_name" ]
then
	echo "No kernel entered"
        exit 1 ## Set a failed and return code
fi
# Start confirmation challenge
printf "Are you sure that the kernel version you want to build for is $kernel_name? (yes/no)\n"
read answer
if [ -z "$answer" ]
then
        echo "No confirmation entered"
        exit 1 ## Set a failed and return code
fi

########################################################################
#          Begin kernel build, copy,  and appropriate sorting          #
########################################################################

# printf "Making dep... \n"
# make dep

printf "Making clean... \n"
make clean &&

printf "Making bzImage... \n"
make bzImage &&

printf "Making modules... \n"
make modules &&

printf "Copying kernel image to boot directory and archiv... \n"
mv /boot/vmlinuz-[$kernel_name] /boot/vmlinuz-[$kernel_name].old &&
cp arch/x86/boot/bzImage /boot/vmlinuz-[$kernel_name] &&

printf "Copying System.map and nameing appropriately... \n"
mv /boot/System.map-[$kernel_name] /boot/System.map-[$kernel_name].old &&
cp System.map /boot/System.map-[$kernel_name] &&

printf "Copying config from src root to boot and naming... \n"
mv /boot/config-[$kernel_name] /boot/config-[$kernel_name].old &&
cp .config /boot/config-[$kernel_name]

printf "Installing made modules... \n"
make modules_install

printf "Building new grub config... \n"
/usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg

