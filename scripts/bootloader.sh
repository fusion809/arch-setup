if [[ $BOOT == "BIOS" ]]; then
	echo "What bootloader do you want to use?"
	read $BOOTLOADER
	if [[ $BOOTLOADER == "GRUB2" ]]; then
		/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm grub
		/usr/bin/arch-chroot ${TARGET_DIR} grub-install --target=i386-pc $DISK
		/usr/bin/arch-chroot ${TARGET_DIR} grub-mkconfig -o /boot/grub/grub.cfg
	elif [[ $BOOTLOADER== "syslinux" ]]; then
		/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm syslinux
		/usr/bin/arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
		/usr/bin/sed -i 's/sda3/sda1/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
		/usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
	fi

elif [[ $BOOT == "UEFI" ]]; then
	parted /dev/sda print
	echo "What partition number is your ESP partition on?"
	read $ESPNO
	ESP=${TARGET_DIR}/boot/efi
	mount /dev/sda$ESPNO $ESP
	cp /boot/initramfs*.img $ESP
	cp /boot/vmlinuz-linux $ESP
	bootctl --path=$ESP install
	echo "#timeout 3
default arch
timeout 4
editor  0" > $ESP/loader/loader.conf
	my_uuid=$(lsblk /dev/sdb1 -no UUID)
	echo "title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=UUID=${my_uuid} rw" > $ESP/loader/entries/arch.conf
else
	echo "You must set your hardware initialization firmware as either BIOS or UEFI"
	read BOOT
	. "scripts/bootloader.sh"
fi
