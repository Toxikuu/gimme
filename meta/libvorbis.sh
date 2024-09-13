NAME="libvorbis"
VERS="1.3.7"
TYPE="extra"
DEPS=""
LINK="https://downloads.xiph.org/releases/vorbis/libvorbis-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make

  make install &&
  install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.7

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
