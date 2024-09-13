NAME="man-db"
VERS="2.13.0"
TYPE="core"
DEPS=""
LINK="https://download.savannah.gnu.org/releases/man-db/man-db-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr                             \
              --docdir=/usr/share/doc/man-db-$VERS \
              --sysconfdir=/etc                         \
              --disable-setuid                          \
              --enable-cache-owner=bin                  \
              --with-browser=/usr/bin/lynx              \
              --with-vgrind=/usr/bin/vgrind             \
              --with-grap=/usr/bin/grap                 \
              --with-systemdtmpfilesdir=                \
              --with-systemdsystemunitdir=
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
