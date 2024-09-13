NAME="opus"
VERS="1.5.2"
TYPE="extra"
DEPS=""
LINK="https://downloads.xiph.org/releases/opus/opus-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr        \
              --buildtype=release  \
              -D docdir=/usr/share/doc/opus-1.5.2 &&
  ninja
  ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup --prefix=/usr            \
              --libdir=/usr/lib32      \
              --buildtype=release

  ninja

  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rv /usr/include/opus             \
  /usr/lib{,32}/libopus.so*
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
