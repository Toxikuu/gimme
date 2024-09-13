NAME="libxcvt"
VERS="0.1.2"
TYPE="extra"
DEPS=""
LINK="https://www.x.org/pub/individual/lib/libxcvt-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
  ninja && ninja install

  rm -rvf *
  CC="gcc -m32" CXX="g++ -m32"            \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32      \
  meson setup --prefix=$XORG_PREFIX       \
              --libdir=$XORG_PREFIX/lib32 \
              --buildtype=release ..      &&
  ninja
  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  rm -rvf DESTDIR
  ldconfig
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
