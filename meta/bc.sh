NAME="bc"
VERS="7.0.1"
TYPE="extra"
DEPS=""
LINK="https://github.com/gavinhoward/bc/releases/download/$VERS/bc-$VERS.tar.xz"

get() {
  CC=gcc ./configure --prefix=/usr -G -O3 -r &&
  make && make install
}

remove() {
  rm -v /bin/{b,d}c
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
