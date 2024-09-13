NAME="efivar"
VERS="39"
TYPE="extra"
DEPS="mandoc"
LINK="https://github.com/rhboot/efivar/archive/$VERS/efivar-$VERS.tar.gz"

get() {
  make &&
  sudo make install LIBDIR=/usr/lib
}

remove() {
  rm -rv                  \
  /usr/bin/efisecdb       \
  /usr/bin/efivar         \
  /usr/lib/libefisec.so*  \
  /usr/lib/libefivar.so*  \
  /usr/lib/libefiboot.so* \
  /usr/include/efivar
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
