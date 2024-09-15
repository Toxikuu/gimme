NAME="glib-full"
VERS="2.82.0"
GOBJECT_VERS="1.82.0"
TYPE="core"
DEPS="docutils libxslt pcre2 shared-mime-info desktop-file-utils"
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
        -D man-pages=enabled      \
        -D sysprof=disabled       &&
  ninja &&
  ninja install &&

  pushd ../..
  wget https://download.gnome.org/sources/gobject-introspection/$(echo $GOBJECT_VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/gobject-introspection-$GOBJECT_VERS.tar.xz
  popd
  tar xvf ../../gobject-introspection-$GOBJECT_VERS.tar.xz &&
  meson setup gobject-introspection-$GOBJECT_VERS gi-build \
            -D cairo=disabled -D doctool=disabled   \
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
