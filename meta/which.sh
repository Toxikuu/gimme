NAME="which"
VERS="2.21"
TYPE="extra"
DEPS=""
LINK="https://ftp.gnu.org/gnu/which/which-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr &&
  make && make install
}

remove() {
  rm -fv /usr/bin/which
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
