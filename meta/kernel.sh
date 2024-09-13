NAME="kernel"
VERS="6.11-rc7"
TYPE="critical"
DEPS=""
LINK="https://git.kernel.org/torvalds/t/linux-$VERS.tar.gz"

get() {
  make mrproper &&
  cp -iv /boot/config-6.11 .config &&
  make &&
  make install &&
  make modules_install &&
  cp -iv arch/x86/boot/bzImage /boot/vmlinuz-$VERS-tox
  cp -iv System.map /boot/System.map-$VERS
  cp -iv .config /boot/config-$VERS
  cp -iv /efi/EFI/LFS/tox64.efi{,.bak}
  cp -iv /boot/vmlinuz-$VERS-tox /efi/EFI/LFS/tox64.efi
}

remove() {
  echo not implemented
}



vars() {
echo "$NAME"
echo "$VERS"
echo "$TYPE"
echo "$DEPS"
echo "$LINK"
}

case $1 in 
  get)
    get
    ;;
  remove)
    remove
    ;;
  vars)
    vars
    ;;
  *)
    echo "INVALID \$1: $1"
    exit 1
    ;;
esac
