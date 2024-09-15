NAME="libclc"
VERS="18.1.7"
TYPE="extra"
DEPS="llvm spirv-llvm-translator"
LINK="https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERS/libclc-$VERS.src.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_INSTALL_PREFIX=/usr \
        -D CMAKE_BUILD_TYPE=Release  \
        -G Ninja .. &&

  ninja && ninja install
}

remove() {
  rm -rvf /usr/include/clc/          \
    /usr/share/clc/
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
