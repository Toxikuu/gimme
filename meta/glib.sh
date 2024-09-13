NAME="glib"
VERS="2.82.0"
TYPE="core"
DEPS=""
LINK="https://download.gnome.org/sources/glib/$(echo \"$VERS\" | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/glib-$VERS.tar.xz"

get() {
  wget https://download.gnome.org/sources/gobject-introspection/1.80/gobject-introspection-1.80.1.tar.xz
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
        -D man-pages=enabled      \
        -D sysprof=disabled       &&
  ninja &&
  ninja install &&
  tar xvf ../gobject-introspection-1.80.1.tar.xz &&
  meson setup gobject-introspection-1.80.1 gi-build \
            --prefix=/usr --buildtype=release     &&
  ninja -C gi-build &&
  ninja -C gi-build install &&
  meson configure -D introspection=enabled &&
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
