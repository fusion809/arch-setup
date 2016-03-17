# Variable definitions

## DISK
echo "Which disk do you wish to install Arch Linux on?"
read DISK

## Whole disk
echo "Do you want to use the entire disk? [y/n]"
read ENTIRE

## KEYMAP
KEYMAP='us'

## LANGUAGE
echo "Which language locale do you wish to use? If you just press enter, the default option of en_AU.UTF-8 will be used. "
read LANGUAGE
if [[ -z ${LANGUAGE+x} ]]; then
	LANGUAGE='en_AU.UTF-8'
fi

## USERNAME
echo "What username do you want your administrator account to have?"
read USERNAME

## USER PASSWORD
echo "What user password, do you want to use?"
read USER_PASSWORD

## ROOT PASSWORD
echo "What root password, would you like to use?"
read ROOT_PASSWORD

## TIMEZONE
echo "What timezone are you in? If you press enter without entering any value,
the default value of the Australian Eastern Standard Time (AEST) will be used."
read TIMEZONE
if [[ -z ${TIMEZONE+x} ]]; then
	TIMEZONE='UTC+10'
fi

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
TARGET_DIR='/mnt'

## Mount EFI partition
echo "What type of firmware does your computer use for hardware initialization? Answer either BIOS or UEFI."
read BOOT
