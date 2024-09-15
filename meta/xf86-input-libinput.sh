NAME="xf86-input-libinput"
VERS="1.4.0"
TYPE="extra"
DEPS="libinput xorg-server"
LINK="https://www.x.org/pub/individual/driver/xf86-input-libinput-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG &&
  make && make install
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
