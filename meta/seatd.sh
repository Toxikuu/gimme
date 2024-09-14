NAME="seatd"
VERS="0.8.0"
TYPE="extra"
DEPS="elogind"
LINK="https://git.sr.ht/~kennylevinsen/seatd/archive/$VERS.tar.gz"

get() {
  mkdir build                  &&
  cd    build

  meson setup --prefix=/usr .. &&
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
