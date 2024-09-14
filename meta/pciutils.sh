NAME="pciutils"
VERS="3.13.0"
TYPE="extra"
DEPS="hwdata"
LINK="https://mj.ucw.cz/download/linux/pci/pciutils-$VERS.tar.gz"

get() {
  sed -r '/INSTALL.*(PCI_IDS|update-pciids)/d' \
      -i Makefile

  make PREFIX=/usr                \
       SHAREDIR=/usr/share/hwdata \
       SHARED=yes

  make PREFIX=/usr                \
       SHAREDIR=/usr/share/hwdata \
       SHARED=yes                 \
       install install-lib        &&

  chmod -v 755 /usr/lib/libpci.so
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
