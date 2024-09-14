NAME="nghttp2"
VERS="1.63.0"
TYPE="extra"
DEPS="libxml2"
LINK="https://github.com/nghttp2/nghttp2/releases/download/v$VERS/nghttp2-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr   \
            --disable-static  \
            --enable-lib-only \
            --docdir=/usr/share/doc/nghttp2-$VERS &&
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
