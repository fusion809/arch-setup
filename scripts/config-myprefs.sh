echo '==> generating the system configuration script'
/usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

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

  echo "[home_fusion809_arch_extra_Arch_Extra]
SigLevel = Never
Server = http://download.opensuse.org/repositories/home:/fusion809:/arch_extra/Arch_Extra/$arch" >> /etc/pacman.conf
  pacman -Syu --noconfirm
  pacman -S broadcom-wl-dkms

	chsh -s /bin/zsh $USERNAME
	chsh -s /bin/zsh
	cd /home/$USERNAME
	git clone https://github.com/robbyrussell/oh-my-zsh .oh-my-zsh
	mkdir GitHub
	git clone https://github.com/fusion809/arch-scripts GitHub/arch-scripts
	cp -a GitHub/arch-scripts/{Shell,.bashrc,.zshrc} .
	cp -a GitHub/arch-scripts/root/{Shell,.bashrc,.zshrc} /root/

	# clean up
	/usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"
