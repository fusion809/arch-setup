if [[ $BOOT == "BIOS" ]]; then
	/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm grub
	/usr/bin/arch-chroot ${TARGET_DIR} grub-install --target=i386-pc $DISK
	/usr/bin/arch-chroot ${TARGET_DIR} grub-mkconfig -o /boot/grub/grub.cfg

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
fi
