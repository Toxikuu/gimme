NAME="docutils"
VERS="0.21.2"
TYPE="extra"
DEPS="python"
LINK="https://files.pythonhosted.org/packages/source/d/docutils/docutils-$VERS.tar.gz"

get() {
  # for f in /usr/bin/rst*.py; do
  #   rm -fv /usr/bin/$(basename $f .py)
  # done

  pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
  pip3 install --no-index --find-links=dist --no-cache-dir --no-user docutils
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
