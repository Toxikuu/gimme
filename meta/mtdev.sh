NAME="mtdev"
VERS="1.1.7"
TYPE=""
DEPS=""
LINK="url: https://bitmath.org/code/mtdev/mtdev-$VERS.tar.bz2"

get() {
  ./configure --prefix=/usr --disable-static &&
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
