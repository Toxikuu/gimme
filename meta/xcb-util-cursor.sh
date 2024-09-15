NAME="xcb-util-cursor"
VERS="0.1.5"
TYPE="extra"
DEPS="xcb-util-image xcb-util-renderutil"
LINK="https://xcb.freedesktop.org/dist/xcb-util-cursor-$VERS.tar.xz"

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
