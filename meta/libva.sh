NAME="libva"
VERS="2.22.0"
TYPE="extra"
DEPS="libdrm"
LINK="https://github.com/intel/libva/archive/$VERS/libva-$VERS.tar.gz"

get() {
  cd build &&

  meson setup --prefix=$XORG_PREFIX --buildtype=release &&
  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"                 \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  meson setup --prefix=$XORG_PREFIX            \
              --libdir=$XORG_PREFIX/lib32      \
              --buildtype=release &&
  ninja &&
  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rvf /usr/include/va/             \
    /usr/lib{,32}/libva-drm.so*        \
    /usr/lib{,32}/libva-glx.so*        \
    /usr/lib{,32}/libva.so*            \
    /usr/lib{,32}/libva-wayland.so*    \
    /usr/lib{,32}/libva-x11.so*
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
