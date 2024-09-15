NAME="libinput"
VERS="1.26.2"
TYPE="extra"
DEPS="libevdev mtdev"
LINK="https://gitlab.freedesktop.org/libinput/libinput/-/archive/$VERS/libinput-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX     \
              --buildtype=release       \
              -D debug-gui=false        \
              -D tests=false            \
              -D libwacom=false         \
              -D udev-dir=/usr/lib/udev \
              .. &&

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
