NAME="markupsafe"
VERS="2.1.5"
TYPE="core"
DEPS=""
LINK="https://pypi.org/packages/source/M/MarkupSafe/MarkupSafe-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
  pip3 install --no-index --no-user --find-links dist Markupsafe
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
