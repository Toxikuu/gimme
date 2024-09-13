NAME="meson"
VERS="1.5.1"
TYPE="core"
DEPS=""
LINK="https://github.com/mesonbuild/meson/releases/download/$VERS/meson-$VERS.tar.gz"

get() {
  pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

  pip3 install --no-index --find-links dist meson
  install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
  install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
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
