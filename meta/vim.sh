NAME="vim"
VERS="9.1.0660"
TYPE="core"
DEPS=""
LINK="https://github.com/vim/vim/archive/v$VERS/vim-$VERS.tar.gz"

get() {
  echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
  ./configure --prefix=/usr
  make
  make install
  ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.0660
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
