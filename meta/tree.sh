NAME="tree"
VERS="2.1.3"
TYPE="extra"
DEPS=""
LINK="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/$VERS/unix-tree-$VERS.tar.bz2"

get() {
  make &&
  make PREFIX=/usr MANDIR=/usr/share/man install
}

remove() {
  rm -vf /usr/bin/tree /usr/share/man/man1/tree.1
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
