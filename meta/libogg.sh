NAME="libogg"
VERS="1.3.5"
TYPE="extra"
DEPS=""
LINK="https://downloads.xiph.org/releases/ogg/libogg-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr    \
              --disable-static \
              --docdir=/usr/share/doc/libogg-$VERS

  make
  make install
  make distclean

  CC="gcc -m32" CXX="g++ -m32"         \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
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
