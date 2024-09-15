NAME="libvdpau-va-gl"
VERS="0.4.2"
TYPE="extra"
DEPS="cmake libvdpau libva"
LINK="https://github.com/i-rinat/libvdpau-va-gl/archive/v$VERS/libvdpau-va-gl-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
  make && make install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"                 \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  cmake -D CMAKE_BUILD_TYPE=Release            \
        -D CMAKE_INSTALL_PREFIX=$XORG_PREFIX   \
        -D CMAKE_INSTALL_LIBDIR=lib32          \
        .. &&

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  rm -rf DESTDIR
  ldconfig

  echo "export VDPAU_DRIVER=va_gl" >> /etc/profile
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
