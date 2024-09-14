NAME="spirv-tools"
VERS="1.3.290.0"
TYPE="extra"
DEPS="cmake spirv-headers"
LINK="https://github.com/KhronosGroup/SPIRV-Tools/archive/vulkan-sdk-$VERS/SPIRV-Tools-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_INSTALL_PREFIX=/usr     \
        -D CMAKE_BUILD_TYPE=Release      \
        -D SPIRV_WERROR=OFF              \
        -D BUILD_SHARED_LIBS=ON          \
        -D SPIRV_TOOLS_BUILD_STATIC=OFF  \
        -D SPIRV-Headers_SOURCE_DIR=/usr \
        -G Ninja .. &&
  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"           \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig   \
  cmake -D CMAKE_INSTALL_PREFIX=/usr     \
        -D CMAKE_INSTALL_LIBDIR=lib32    \
        -D CMAKE_BUILD_TYPE=Release      \
        -D SPIRV_WERROR=OFF              \
        -D BUILD_SHARED_LIBS=ON          \
        -D SPIRV_TOOLS_BUILD_STATIC=OFF  \
        -D SPIRV-Headers_SOURCE_DIR=/usr \
        -G Ninja .. &&

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
