NAME="luit"
VERS="20240910"
TYPE="extra"
DEPS="xorg-applications"
LINK="https://invisible-mirror.net/archives/luit/luit-$VERS.tgz"

get() {
  ./configure $XORG_CONFIG &&
  make && make install
}

remove() {
  rm -vf /usr/bin/luit
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
