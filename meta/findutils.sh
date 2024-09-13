NAME="findutils"
VERS="4.10.0"
TYPE="core"
DEPS=""
LINK="https://ftp.gnu.org/gnu/findutils/findutils-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr --localstatedir=/var/lib/locate
  make
  make install
}

remove() {
  sudo rm -rv /usr/bin/find \
  /usr/bin/locate           \
  /usr/bin/updatedb         \
  /usr/bin/xargs            \
  /var/lib/locate
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
