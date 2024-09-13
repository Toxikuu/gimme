NAME="iana-etc"
VERS="20240829"
TYPE="core"
DEPS=""
LINK="https://github.com/Mic92/iana-etc/releases/download/$VERS/iana-etc-$VERS.tar.gz"

get() {
  cp services protocols /etc
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
