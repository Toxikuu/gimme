NAME="expat"
VERS="2.6.3"
TYPE=""
DEPS=""
LINK="https://prdownloads.sourceforge.net/expat/expat-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr    \
              --disable-static \
              --docdir=/usr/share/doc/expat-$VERS &&
  make && make install &&
  sed -e "/^am__append_1/ s/doc//" -i Makefile &&
  make clean &&
  CC="gcc -m32" ./configure \
    --prefix=/usr        \
    --disable-static     \
    --libdir=/usr/lib32  \
    --host=i686-pc-linux-gnu &&
  make &&
  make DESTDIR=$PWD/DESTDIR install &&
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32 &&
  rm -rf DESTDIR
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
