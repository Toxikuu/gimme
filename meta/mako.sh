NAME="mako"
VERS="1.3.5"
TYPE="extra"
DEPS=""
LINK="https://files.pythonhosted.org/packages/source/M/Mako/Mako-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
  pip3 install --no-index --find-links=dist --no-cache-dir --no-user Mako
}

remove() {
  rm -rvf /usr/bin/mako-render             \
    /usr/lib/python3.12/site-packages/mako \
    /usr/lib/python3.12/site-packages/Mako-$VERS.dist-info
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
