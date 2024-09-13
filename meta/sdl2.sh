NAME="sdl2"
VERS="2.30.7"
TYPE=""
DEPS=""
LINK="https://www.libsdl.org/release/SDL2-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr &&
  make &&
  make install &&
  rm -v /usr/lib/libSDL2*.a
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
