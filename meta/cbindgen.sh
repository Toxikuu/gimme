NAME="cbindgen"
VERS="0.27.0"
TYPE="extra"
DEPS="rustc"
LINK="https://github.com/mozilla/cbindgen/archive/v$VERS/cbindgen-$VERS.tar.gz"

get() {
  cargo build --release
  install -Dm755 target/release/cbindgen /usr/bin/
}

remove() {
  rm -vf /usr/bin/cbindgen
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
