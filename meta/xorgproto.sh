NAME="xorgproto"
VERS="2024.1"
TYPE="extra"
DEPS="util-macros"
LINK="https://xorg.freedesktop.org/archive/individual/proto/xorgproto-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX .. &&
  ninja

  ninja install &&
  mv -v $XORG_PREFIX/share/doc/xorgproto{,-2024.1}
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
