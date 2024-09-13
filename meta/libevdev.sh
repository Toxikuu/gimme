NAME="libevdev"
VERS="1.13.3"
TYPE=""
DEPS=""
LINK="https://www.freedesktop.org/software/libevdev/libevdev-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup ..                \
      --prefix=$XORG_PREFIX     \
      --buildtype=release       \
      -D documentation=disabled &&
  ninja && ninja install
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
