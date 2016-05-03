# Disk formatting
if [[ $ENTIRE == y ]]; then
  ROOT_PARTITION="${DISK}1"
  echo "==> clearing partition table on ${DISK}"
  /usr/bin/sgdisk --zap ${DISK}

  echo "==> destroying magic strings and signatures on ${DISK}"
  /usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
  /usr/bin/wipefs --all ${DISK}

  echo "==> creating /root partition on ${DISK}"
  /usr/bin/sgdisk --new=1:0:0 ${DISK}

  echo "==> setting ${DISK} bootable"
  /usr/bin/sgdisk ${DISK} --attributes=1:set:2

  echo '==> creating /root filesystem (ext4)'
  /usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}
elif [[ $ENTIRE == n ]]; then
  echo "Which partition number do you want to install Arch Linux on?"
  read $PART_NO
  ROOT_PARTITION="${DISK}${PART_NO}"
fi
