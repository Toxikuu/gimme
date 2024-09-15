NAME="pyyaml"
VERS="6.0.2"
TYPE="extra"
DEPS="cython libyaml"
LINK="https://files.pythonhosted.org/packages/source/P/PyYAML/pyyaml-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
  pip3 install --no-index --find-links=dist --no-cache-dir --no-user PyYAML
}

remove() {
  rm -rvf /usr/lib/python3.12/site-packages/PyYAML-$VERS.dist-info/
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
