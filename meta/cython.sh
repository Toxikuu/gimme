NAME="cython"
VERS="3.0.11"
TYPE="extra"
DEPS=""
LINK="https://github.com/cython/cython/releases/download/$VERS-1/cython-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
  pip3 install --no-index --find-links=dist --no-cache-dir --no-user Cython
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
