PACKAGES="gptfdisk wpa_supplicant dialog git zsh openssh"
/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm $PACKAGES
