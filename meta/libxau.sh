NAME="libxau"
VERS="1.0.11"
TYPE="extra"
DEPS="xorgproto"
LINK="https://www.x.org/pub/individual/lib/libXau-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG &&
  make

  make install
  make distclean

  CC="gcc -m32" CXX="g++" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  ./configure $XORG_CONFIG --libdir=$XORG_PREFIX/lib32 &&
  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rvf /usr/lib{,32}/libXau.*
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
