PACKAGES="gptfdisk wpa_supplicant dialog git zsh"
/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm $PACKAGES
