NAME="sysvinit"
VERS="3.10"
TYPE="core"
DEPS=""
LINK="https://github.com/slicer69/sysvinit/releases/download/$VERS/sysvinit-$VERS.tar.xz"

get() {
  wget https://www.linuxfromscratch.org/patches/lfs/development/sysvinit-3.10-consolidated-1.patch
  patch -Np1 -i ./sysvinit-3.10-consolidated-1.patch

  make && make install
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
