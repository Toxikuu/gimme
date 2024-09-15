NAME="xcursor-themes"
VERS="1.0.7"
TYPE="extra"
DEPS="xorg-applications"
LINK="https://www.x.org/pub/individual/data/xcursor-themes-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr &&
  make && make install
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
