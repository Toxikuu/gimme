NAME="freetype"
VERS="2.13.3"
TYPE="extra"
DEPS="harfbuzz libpng which"
LINK="https://downloads.sourceforge.net/freetype/freetype-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr --enable-freetype-config --disable-static &&
  make && make install

  make distclean

  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --enable-freetype-config \
              --disable-static

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
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
