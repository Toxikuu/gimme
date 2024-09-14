NAME="glslang"
VERS="14.3.0"
TYPE="extra"
DEPS="cmake spirv-tools"
LINK="https://github.com/KhronosGroup/glslang/archive/$VERS/glslang-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_INSTALL_PREFIX=/usr     \
        -D CMAKE_BUILD_TYPE=Release      \
        -D ALLOW_EXTERNAL_SPIRV_TOOLS=ON \
        -D BUILD_SHARED_LIBS=ON          \
        -D GLSLANG_TESTS=ON              \
        -G Ninja .. &&

  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"           \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig   \
  cmake -D CMAKE_INSTALL_PREFIX=/usr     \
        -D CMAKE_INSTALL_LIBDIR=lib32    \
        -D CMAKE_BUILD_TYPE=Release      \
        -D ALLOW_EXTERNAL_SPIRV_TOOLS=ON \
        -D BUILD_SHARED_LIBS=ON          \
        -D GLSLANG_TESTS=ON              \
        -G Ninja .. &&

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
