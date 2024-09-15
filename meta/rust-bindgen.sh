NAME="rust-bindgen"
VERS="0.70.1"
TYPE="extra"
DEPS="llvm rustc" # with clang
LINK="https://github.com/rust-lang/rust-bindgen/archive/v$VERS.tar.gz"

get() {
  cargo build --release
  install -Dm755 target/release/bindgen /usr/bin/
}

remove() {
  rm -vf /usr/bin/bindgen
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
