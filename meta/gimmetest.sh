NAME="gimmetest"
VERS="0.0.0"
TYPE="extra"
DEPS=""
LINK=""

get() {
  whoami
  su -c "whoami" test
  # test some stuff with multiline su -c later
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
