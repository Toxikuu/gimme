NAME="libepoxy"
VERS="1.5.10"
TYPE="extra"
DEPS="mesa"
LINK="https://download.gnome.org/sources/libepoxy/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/libepoxy-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

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
