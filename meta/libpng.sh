NAME="libpng"
VERS="1.6.43"
TYPE="extra"
DEPS=""
LINK="https://downloads.sourceforge.net/libpng/libpng-$VERS.tar.xz"

get() {
  wget https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-$VERS-apng.patch.gz
  gzip -cd ./libpng-$VERS-apng.patch.gz | patch -p1

  ./configure --prefix=/usr --disable-static &&
  make

  make install &&
  mkdir -v /usr/share/doc/libpng-$VERS &&
  cp -v README libpng-manual.txt /usr/share/doc/libpng-$VERS

  make distclean
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
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
