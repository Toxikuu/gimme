NAME="libyaml"
VERS="0.2.5"
TYPE="extra"
DEPS=""
LINK="https://github.com/yaml/libyaml/releases/download/$VERS/yaml-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make && make install
}

remove() {
  rm -vf /usr/lib{,32}/libyaml.{la,so} \
    /usr/lib/libyaml-0.so*
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
