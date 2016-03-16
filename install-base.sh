#!/usr/bin/env bash

echo "Welcome to fusion809's automated Arch Linux installer, \nforked from https://github.com/elasticdog/packer-arch's install-base.sh script"

. "scripts/variables.sh"

. "scripts/disks.sh"

# Mount partition to target directory
echo "==> mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

# Bootstrapping base installation.
echo '==> bootstrapping the base installation'
/usr/bin/pacstrap ${TARGET_DIR} base base-devel
. "scripts/bootloader.sh"

echo '==> generating the filesystem table'
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

echo '==> generating the system configuration script'
/usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

. "scripts/config.sh"

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"

echo '==> adding workaround for shutdown race condition'
/usr/bin/install --mode=0644 poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo '==> installation complete!'
/usr/bin/sleep 3
/usr/bin/umount ${TARGET_DIR}
/usr/bin/systemctl reboot
