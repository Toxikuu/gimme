NAME="i3"
VERS="4.23"
TYPE="extra"
DEPS="xcb-util-keysyms xcb-util-wm libev yajl startup-notification pango perl xcb-util-cursor xcb-util-xrm"
LINK="https://github.com/i3/i3/archive/refs/tags/$VERS.tar.gz"

get() {
  mkdir -pv build && 
  cd        build &&
  meson setup .. --prefix=/usr --buildtype=release &&
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
