NAME="tar"
VERS="1.35"
TYPE="core"
DEPS=""
LINK="https://ftp.gnu.org/gnu/tar/tar-$VERS.tar.xz"

get() {
  FORCE_UNSAFE_CONFIGURE=1  \
  ./configure --prefix=/usr

  make && make install
  make -C doc install-html docdir=/usr/share/doc/tar-$VERS
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
