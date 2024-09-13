NAME="libpsl"
VERS="0.21.5"
TYPE="extra"
DEPS=""
LINK="https://github.com/rockdaboot/libpsl/releases/download/$VERS/libpsl-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr --buildtype=release &&

  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup ..                       \
        --prefix=/usr                  \
        --libdir=/usr/lib32            \
        --buildtype=release &&

  ninja
  DESTDIR=$PWD/DESTDIR ninja install
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
