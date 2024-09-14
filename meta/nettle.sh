NAME="nettle"
VERS="3.10"
TYPE="extra"
DEPS=""
LINK="https://ftp.gnu.org/gnu/nettle/nettle-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make

  make install &&
  chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
  install -v -m755 -d /usr/share/doc/nettle-3.10 &&
  install -v -m644 nettle.{html,pdf} /usr/share/doc/nettle-3.10
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
