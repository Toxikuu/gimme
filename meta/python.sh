NAME="python"
VERS="3.12.6"
TYPE=""
DEPS=""
LINK="https://www.python.org/ftp/python/$VERS/Python-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr        \
              --enable-shared      \
              --with-system-expat  \
              --enable-optimizations

  make && make install
  
  cat > /etc/pip.conf << EOF
  [global]
  root-user-action = ignore
  disable-pip-version-check = true
EOF
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
