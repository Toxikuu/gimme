NAME="pango"
VERS="1.54.0"
TYPE="extra"
DEPS="fontconfig freetype harfbuzz fribidi glib-full cairo xorg-libraries"
LINK="https://download.gnome.org/sources/pango/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/pango-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr          \
              --buildtype=release    \
              --wrap-mode=nofallback \
              ..                     &&
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
