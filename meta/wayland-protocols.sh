NAME="wayland-protocols"
VERS="1.37"
TYPE=""
DEPS=""
LINK="url: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/$VERS/downloads/wayland-protocols-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr --buildtype=release &&
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
