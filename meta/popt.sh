NAME="popt"
VERS="1.19"
TYPE="extra"
DEPS=""
LINK="http://ftp.rpm.org/popt/releases/popt-1.x/popt-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make &&
  make install
}

remove() {
  rm -v /usr/lib/libpopt.so* /usr/lib/libpopt.la
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
