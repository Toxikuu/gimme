NAME="vulkan-loader"
VERS="1.3.295"
TYPE=""
DEPS=""
LINK="https://github.com/KhronosGroup/Vulkan-Headers/archive/v$VERS/Vulkan-Headers-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
  ninja && ninja install &&
  rm -rf *
  ASFLAGS=--32 CFLAGS=-m32 CXXFLAGS=-m32 \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig   \
  cmake -D CMAKE_INSTALL_PREFIX=/usr     \
        -D CMAKE_INSTALL_LIBDIR=lib32    \
        -D CMAKE_BUILD_TYPE=Release      \
        -D CMAKE_SKIP_INSTALL_RPATH=ON   \
        -G Ninja ..

  ninja &&
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
