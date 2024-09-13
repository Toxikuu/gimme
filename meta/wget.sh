NAME="wget"
VERS="1.24.5"
TYPE=""
DEPS=""
LINK="https://ftp.gnu.org/gnu/wget/wget-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr      \
              --sysconfdir=/etc  \
              --with-ssl=openssl &&
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
