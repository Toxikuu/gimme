NAME="libunwind"
VERS="1.6.2"
TYPE="extra"
DEPS=""
LINK="https://download.savannah.nongnu.org/releases/libunwind/libunwind-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make && make install

  make distclean
  CC="gcc -m32" CXX="g++ -m32"                     \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig             \
  CFLAGS+=" -Wno-error=incompatible-pointer-types" \
  ./configure --prefix=/usr                        \
              --libdir=/usr/lib32                  \
              --host=i686-pc-linux-gnu             \
              --disable-static &&

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  cp -v DESTDIR/usr/include/libunwind-x86.h /usr/include
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -vf /usr/lib{,32}/libunwind*
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
