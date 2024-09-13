NAME="sudo"
VERS="1.9.16"
TYPE=""
DEPS=""
LINK="https://www.sudo.ws/dist/sudo-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr                           \
              --libexecdir=/usr/lib                   \
              --with-secure-path                      \
              --with-env-editor                       \
              --docdir=/usr/share/doc/sudo-$VERS \
              --with-passprompt="[sudo] password for %p: " &&
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
