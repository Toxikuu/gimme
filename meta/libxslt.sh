NAME="libxslt"
VERS="1.1.42"
TYPE="extra"
DEPS="libxml2 docbook-xml docbook-xsl-nons"
LINK="https://download.gnome.org/sources/libxslt/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/libxslt-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr                          \
              --disable-static                       \
              --docdir=/usr/share/doc/libxslt-1.1.42 &&
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
