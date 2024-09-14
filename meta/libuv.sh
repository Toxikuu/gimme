NAME="libuv"
VERS="1.48.0"
TYPE="extra"
DEPS=""
LINK="https://dist.libuv.org/dist/v$VERS/libuv-v$VERS.tar.gz"

get() {
  sh autogen.sh                              &&
  ./configure --prefix=/usr --disable-static &&
  make && make install
}

remove() {
  rm -rvf /usr/include/uv/      \
  /usr/lib/libuv.la             \
  /usr/lib/libuv.so*
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
