NAME="kbd"
VERS="2.6.4"
TYPE="core"
DEPS=""
LINK="https://www.kernel.org/pub/linux/utils/kbd/kbd-$VERS.tar.xz"

get() {
  wget https://www.linuxfromscratch.org/patches/lfs/development/kbd-$VERS-backspace-1.patch
  patch -Np1 -i ./kbd-2.6.4-backspace-1.patch

  sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
  sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

  ./configure --prefix=/usr --disable-vlock
  make
  make install
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
