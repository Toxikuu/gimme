NAME="shared-mime-info"
VERS="2.4"
TYPE="extra"
DEPS="glib-no-gobject libxml2"
LINK="https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr --buildtype=release -D update-mimedb=true .. &&
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
