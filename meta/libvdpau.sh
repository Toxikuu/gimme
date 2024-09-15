NAME="libvdpau"
VERS="1.5"
TYPE="extra"
DEPS="xorg-libraries"
LINK="https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/$VERS/libvdpau-$VERS.tar.bz2"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX .. &&
  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"                 \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  meson setup --prefix=$XORG_PREFIX            \
              --libdir=$XORG_PREFIX/lib32      \
              .. &&
  ninja
  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rvf /usr/include/vdpau/                 \
    /usr/lib/vdpau/                           \
    /usr/lib{,32}/libvdpau.so*
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
