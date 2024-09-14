NAME="wayland"
VERS="1.23.1"
TYPE=""
DEPS="libxml2"
LINK="https://gitlab.freedesktop.org/wayland/wayland/-/releases/$VERS/downloads/wayland-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup ..            \
        --prefix=/usr       \
        --buildtype=release \
        -D documentation=false &&
  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup ..                       \
        --prefix=/usr                  \
        --libdir=/usr/lib32            \
        --buildtype=release            \
        -D documentation=false &&
  ninja &&

  DESTDIR=$PWD/DESTDIR ninja install
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32
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
