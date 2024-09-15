NAME="ply"
VERS="3.11"
TYPE="extra"
DEPS=""
LINK="https://files.pythonhosted.org/packages/source/p/ply/ply-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
  pip3 install --no-index --find-links=dist --no-cache-dir --no-user ply
}

remove() {
  rm -rvf /usr/lib/python3.12/site-packages/ply \
    /usr/lib/python3.12/site-packages/ply-$VERS.dist-info
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
