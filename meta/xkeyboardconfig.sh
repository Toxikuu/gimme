NAME="xkeyboard-config"
VERS="2.42"
TYPE="extra"
DEPS="xorg-libraries"
LINK="https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
  ninja && ninja install
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
