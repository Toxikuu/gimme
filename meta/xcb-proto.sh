NAME="xcb-proto"
VERS="1.17.0"
TYPE="extra"
DEPS=""
LINK="https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-$VERS.tar.xz"

get() {
  PYTHON=python3 ./configure $XORG_CONFIG
  make install
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
