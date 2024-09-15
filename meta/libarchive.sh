NAME="libarchive"
VERS="3.7.5"
TYPE="extra"
DEPS="libxml2"
LINK="https://github.com/libarchive/libarchive/releases/download/v$VERS/libarchive-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr --disable-static --without-expat &&
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
