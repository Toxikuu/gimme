NAME="pixman"
VERS="0.43.4"
TYPE="extra"
DEPS=""
LINK="https://www.cairographics.org/releases/pixman-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr --buildtype=release .. &&
  ninja && ninja install
}

remove() {
  rm -rvf /usr/include/pixman-1/    \
  /usr/lib{,32}/libpixman-1.so*
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
