NAME="libunistring"
VERS="1.2"
TYPE="extra"
DEPS=""
LINK="https://ftp.gnu.org/gnu/libunistring/libunistring-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr    \
              --disable-static \
              --docdir=/usr/share/doc/libunistring-1.2 &&
  make
  make install
  make distclean
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --disable-static &&

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
