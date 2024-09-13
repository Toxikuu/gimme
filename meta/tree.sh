NAME="tree"
VERS="version: 2.1.3"
TYPE=""
DEPS=""
LINK="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/$VERS/unix-tree-$VERS.tar.bz2"

get() {
  make &&
  make PREFIX=/usr MANDIR=/usr/share/man install
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
