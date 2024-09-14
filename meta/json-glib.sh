NAME="json-glib"
VERS="1.10.0"
TYPE=""
DEPS=""
LINK="https://download.gnome.org/sources/json-glib/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/json-glib-$VERS.tar.xz"

get() {
  mkdir -v build && cd build &&
  meson setup --prefix=/usr --buildtype=release .. &&
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
