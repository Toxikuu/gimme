NAME="glib-no-gobject.sh"
VERS="2.82.0"
TYPE="extra"
DEPS=""
LINK="https://download.gnome.org/sources/glib/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/glib-$VERS.tar.xz"

get() {
  if [ -e /usr/include/glib-2.0 ]; then
    rm -rf /usr/include/glib-2.0.old &&
    mv -vf /usr/include/glib-2.0{,.old}
  fi

  mkdir build &&
  cd    build &&

  meson setup ..                  \
        --prefix=/usr             \
        --buildtype=release       \
        -D introspection=disabled \
        -D glib_debug=disabled    \
        -D man-pages=disabled     \
        -D sysprof=disabled       &&
  ninja &&
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
