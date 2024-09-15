NAME="xcb-util-keysyms"
VERS="0.4.1"
TYPE="extra"
DEPS="libxcb"
LINK="https://xcb.freedesktop.org/dist/xcb-util-keysyms-$VERS.tar.xz"

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
