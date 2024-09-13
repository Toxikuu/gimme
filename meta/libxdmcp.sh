NAME="libxdmcp"
VERS="1.1.5"
TYPE="extra"
DEPS="xorgproto"
LINK="https://www.x.org/pub/individual/lib/libXdmcp-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.5 &&
  make && make install

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
