NAME="gzip"
VERS="1.13"
TYPE="core"
DEPS=""
LINK="https://ftp.gnu.org/gnu/gzip/gzip-$VERS.tar.xz"

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
