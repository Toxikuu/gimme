NAME="spirv-headers"
VERS="1.3.290.0"
TYPE="extra"
DEPS="cmake"
LINK="https://github.com/KhronosGroup/SPIRV-Headers/archive/vulkan-sdk-$VERS/SPIRV-Headers-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  cmake -D CMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
  ninja
  ninja install
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
