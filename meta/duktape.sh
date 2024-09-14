NAME="duktape"
VERS="2.7.0"
TYPE="extra"
DEPS=""
LINK="https://duktape.org/duktape-$VERS.tar.xz"

get() {
  sed -i 's/-Os/-O2/' Makefile.sharedlibrary
  make -f Makefile.sharedlibrary INSTALL_PREFIX=/usr
  make -f Makefile.sharedlibrary INSTALL_PREFIX=/usr install
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
