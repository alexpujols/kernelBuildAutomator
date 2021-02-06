#!/bin/bash
#
#                      ::::::
#                    :+:  :+:
#                   +:+   +:+
#                  +#++:++#++:::::::
#                 +#+     +#+     :+:
#               ###       ###+:++#""
#                         +#+
#                         #+#
#                         ###
#
#__author__ = "Alex Pujols"
#__copyright__ = "TBD"
#__credits__ = ["Alex Pujols"]
#__license__ = "GPL"
#__version__ = "1.0"
#__maintainer__ = "Alex Pujols"
#__email__ = "alex.pujols@gmail.com"
#__status__ = "Prototype"
#
#: Title	:	upgrade_script
#: Date		:	7-19-2019
#: Description  :	Upgrade script for Slackware custom kernels
#: Options	:	None
#: Notes	:	Requires Grub2 rather than default eLILO; Must be run as root

########################################################################
# Read in actual kernel image so that we can apply to customize script #
########################################################################

# Start kernel version entry
printf "What is the kernel version you would like to build for? \n => "
read kernel_name
if [ -z "$kernel_name" ]
then
	echo "No kernel entered"
        exit 1 ## Set a failed and return code
fi
# Start confirmation challenge
printf "Are you sure that the kernel version you want to build for is $kernel_name? (yes/no)\n => "
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

# Begin conditional test for vmlinuz image
printf "Copying kernel image to boot directory and archiv... \n"
if [ -f /boot/vmlinuz-${kernel_name} ]; #Checking to see if original file exists
        then
                printf "Old vlinuz kernel image found, moving to backup \n"
                mv /boot/vmlinuz-${kernel_name} /boot/vmlinuz-${kernel_name}.old
        else
                printf "Old vmlinuz config kernel image not found, copying new \n"
fi
cp arch/x86/boot/bzImage /boot/vmlinuz-${kernel_name}


# Begin conditional test for System.map image
printf "Copying System.map and nameing appropriately... \n"
if [ -f /boot/System.map-${kernel_name} ]; #Checking to see if original file exists
        then
                printf "Old System.map kernel image found, moving to backup \n"
                mv /boot/System.map-${kernel_name} /boot/System.map-${kernel_name}.old
        else
                printf "Old System.map kernel image not found, copying new \n"
fi
cp System.map /boot/System.map-${kernel_name}



# Begin conditional test for config image
printf "Copying config from src root to boot and naming... \n"
if [ -f /boot/config-${kernel_name} ]; #Checking to see if original file exists
	then
		printf "Old config kernel image found, moving to backup \n"
		mv /boot/config-${kernel_name} /boot/config-${kernel_name}.old
	else
		printf "Old config kernel image not found, copying new \n"
fi
cp .config /boot/config-${kernel_name}

printf "Setting pointer for boot directory vmlinuz-${kernel_name} \n"
ln -sf /boot/vmlinuz-${kernel_name} /boot/vmlinuz &&

printf "Setting pointer for boot directory System.map-${kernel_name} \n"
ln -sf /boot/System.map-${kernel_name} /boot/System.map &&

printf "Setting pointer for boot directory config-${kernel_name} \n"
ln -sf /boot/config-${kernel_name} /boot/config &&

printf "Setting pointer for /usr/src/linux pointer to kernel ${kernel_name} \n"
ln -sf /usr/src/linux-${kernel_name} /usr/src/linux &&

printf "Installing made modules... \n"
make modules_install &&

# Requires Grub2
printf "Building new grub config... \n"
/usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg
