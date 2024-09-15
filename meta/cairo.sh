NAME="cairo"
VERS="1.18.2"
TYPE="extra"
DEPS="libpng pixman fontconfig glib-no-gobject xorg-libraries"
LINK="https://www.cairographics.org/releases/cairo-$VERS.tar.xz"

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
