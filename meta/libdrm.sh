NAME="libdrm"
VERS="2.4.123"
TYPE=""
DEPS=""
LINK="https://dri.freedesktop.org/libdrm/libdrm-$VERS.tar.xz"

get() {
  ls && mkdir build && cd build
  meson setup --prefix=$XORG_PREFIX \
              --buildtype=release \
              -D udev=true \
              -D valgrind=disabled \
              -D intel=disabled \
              -D radeon=disabled \
              -D amdgpu=disabled \
              -D nouveau=disabled \
              -D vmwgfx=disabled \
              -D tests=false \
              -D cairo-tests=disabled \
              .. &&
  ninja && ninja install &&
  rm -rvf * &&
  CC="gcc -m32" CXX="g++ -m32"                 \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  meson setup --prefix=$XORG_PREFIX            \
              --buildtype=release              \
              --libdir=$XORG_PREFIX/lib32      \
              -D udev=true                     \
              -D valgrind=disabled             \
              -D intel=disabled \
              -D radeon=disabled \
              -D amdgpu=disabled \
              -D nouveau=disabled \
              -D vmwgfx=disabled \
              -D tests=false \
              -D cairo-tests=disabled \
              .. &&
  ninja &&
  DESTDIR=$PWD/DESTDIR ninja install &&
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32 &&
  rm -rf DESTDIR &&
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
