NAME="util-macros"
VERS="1.20.1"
TYPE="extra"
DEPS=""
LINK="https://www.x.org/pub/individual/util/util-macros-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG
  make install
}

remove() {
  rm -rvf $XORG_PREFIX/share/pkgconfig \
    $XORG_PREFIX/share/util-macros
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
