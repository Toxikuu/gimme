NAME="unzip"
VERS="6.0"
TYPE="extra"
DEPS=""
LINK="https://downloads.sourceforge.net/infozip/unzip$(echo $VERS | sed 's/\.//').tar.gz"

get() {
  wget https://www.linuxfromscratch.org/patches/blfs/svn/unzip-$VERS-consolidated_fixes-1.patch
  wget https://www.linuxfromscratch.org/patches/blfs/svn/unzip-$VERS-gcc14-1.patch

  patch -Np1 -i ./unzip-6.0-consolidated_fixes-1.patch
  patch -Np1 -i ./unzip-6.0-gcc14-1.patch

  make -f unix/Makefile generic
  make prefix=/usr MANDIR=/usr/share/man/man1 \
   -f unix/Makefile install
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
