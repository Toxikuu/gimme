NAME="libev"
VERS="4.33"
TYPE="extra"
DEPS="glibc"
LINK="http://dist.schmorp.de/libev/libev-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr
  make
  make install
  rm -vf /usr/include/event.h
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
