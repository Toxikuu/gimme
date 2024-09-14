NAME="hwdata"
VERS="0.386"
TYPE="extra"
DEPS=""
LINK="https://github.com/vcrhonek/hwdata/archive/v$VERS/hwdata-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-blacklist &&
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
