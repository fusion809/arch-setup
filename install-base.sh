#!/usr/bin/env bash
# This script is for automating the installation of Arch Linux and getting it ready for use on a laptop, potentially, with a Broadcom chip.

echo "Welcome to fusion809's automated Arch Linux installer, forked from https://github.com/elasticdog/packer-arch's install-base.sh script."

. "scripts/variables.sh"

. "scripts/disks.sh"

# Mount partition to target directory
echo "==> mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

# Bootstrapping base installation.
echo '==> bootstrapping the base installation'
/usr/bin/pacstrap ${TARGET_DIR} base base-devel
. "scripts/package-base.sh"

. "scripts/bootloader.sh"

echo '==> generating the filesystem table'
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

. "scripts/config-base.sh"

echo '==> adding workaround for shutdown race condition'
/usr/bin/install --mode=0644 poweroff.timer "${TARGET_DIR}/etc/systemd/system/poweroff.timer"

echo '==> installation complete!'
/usr/bin/sleep 3
/usr/bin/umount ${TARGET_DIR}
/usr/bin/systemctl reboot
