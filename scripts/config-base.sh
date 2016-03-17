cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"
	echo '${FQDN}' > /etc/hostname
	/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
	echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf
	/usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
	/usr/bin/locale-gen
	/usr/bin/mkinitcpio -p linux
	/usr/bin/usermod --password ${ROOT_PASSWORD} root

	# Vagrant-specific configuration
	/usr/bin/useradd --password ${USER_PASSWORD} --comment 'administrative user' --create-home --gid users ${USERNAME}
  /usr/bin/gpasswd -a ${USERNAME} wheel

  /usr/bin/sed -i "s/^#%wheel/%wheel/g" /etc/sudoers

	# clean up
	/usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"
