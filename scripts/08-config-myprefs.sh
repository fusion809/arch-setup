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
  /usr/bin/pacman -Syu --noconfirm
  /usr/bin/pacman -S broadcom-wl-dkms yaourt --noconfirm

	/usr/bin/chsh -s /bin/zsh $USERNAME
	/usr/bin/chsh -s /bin/zsh
	cd /home/$USERNAME
	/usr/bin/git clone https://github.com/robbyrussell/oh-my-zsh .oh-my-zsh
	/usr/bin/mkdir GitHub
	/usr/bin/git clone https://github.com/fusion809/arch-scripts GitHub/arch-scripts
	/usr/bin/cp -a GitHub/arch-scripts/{Shell,.bashrc,.zshrc} .
	/usr/bin/cp -a GitHub/arch-scripts/root/{Shell,.bashrc,.zshrc} /root/
	/usr/bin/git clone https://github.com/fusion809/zsh-theme GitHub/zsh-theme
	/usr/bin/cp -a GitHub/zsh-theme/{hcompat,hornix}.zsh-theme .oh-my-zsh/themes/

	# clean up
	/usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"
