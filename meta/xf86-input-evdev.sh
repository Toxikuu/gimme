NAME="xf86-input-evdev"
VERS="2.10.6"
TYPE="extra"
DEPS="libevdev mtdev xorg-server"
LINK="https://www.x.org/pub/individual/driver/xf86-input-evdev-$VERS.tar.bz2"

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
