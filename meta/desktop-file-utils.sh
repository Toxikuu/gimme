NAME="desktop-file-utils"
VERS="0.27"
TYPE="extra"
DEPS="glib"
LINK="https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr --buildtype=release .. &&
  ninja && ninja install

  install -vdm755 /usr/share/applications &&
  update-desktop-database /usr/share/applications
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
