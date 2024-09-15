NAME="xbitmaps"
VERS="1.1.3"
TYPE="extra"
DEPS="util-macros"
LINK="https://www.x.org/pub/individual/data/xbitmaps-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG
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
