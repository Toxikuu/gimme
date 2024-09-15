NAME="xcb-util-xrm"
VERS="1.3"
TYPE="extra"
DEPS="xcb-util"
LINK="https://github.com/Airblader/xcb-util-xrm/releases/download/v$VERS/xcb-util-xrm-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr
  make
  make install
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
