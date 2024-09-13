NAME="check"
VERS="0.15.2"
TYPE="core"
DEPS=""
LINK="https://github.com/libcheck/check/releases/download/$VERS/check-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make &&
  make docdir=/usr/share/doc/check-$VERS install

  make clean
  CC="gcc -m32" CXX="g++ -m32"         \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --disable-static &&

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig
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
