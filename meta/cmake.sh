NAME="cmake"
VERS="3.30.3"
TYPE="core"
DEPS="curl libarchive libuv nghttp2"
LINK="https://cmake.org/files/v$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/cmake-$VERS.tar.gz"

get() {
  sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

  ./bootstrap --prefix=/usr        \
              --system-libs        \
              --mandir=/share/man  \
              --no-system-jsoncpp  \
              --no-system-cppdap   \
              --no-system-librhash \
              --docdir=/share/doc/cmake-$VERS &&
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
