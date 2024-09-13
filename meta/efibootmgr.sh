NAME="efibootmgr"
VERS="18"
TYPE="extra"
DEPS="efivar popt"
LINK="https://github.com/rhboot/efibootmgr/archive/$VERS/efibootmgr-$VERS.tar.gz"

get() {
  make EFIDIR=LFS EFI_LOADER=tox64.efi
  make install EFIDIR=LFS
}

remove() {
  rm -v /usr/sbin/efiboot{mgr,dump}
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
