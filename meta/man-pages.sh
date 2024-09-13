NAME="man-pages"
VERS="6.9.1"
TYPE=""
DEPS=""
LINK="https://www.kernel.org/pub/linux/docs/man-pages/man-pages-$VERS.tar.xz"

get() {
  rm -v man3/crypt*
  make prefix=/usr install
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
