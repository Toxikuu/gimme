NAME="icu"
VERS="75.1"
TYPE="extra"
DEPS=""
LINK="https://github.com/unicode-org/icu/releases/download/release-$(echo $VERS | sed 's/\./-/g')/icu4c-$(echo $VERS | sed 's/\./_/g')-src.tgz"

get() {
  cd source                                    &&

  ./configure --prefix=/usr                    &&
  make && make install

  make clean
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr --libdir=/usr/lib32 --host=i686-pc-linux-gnu &&
  make

  make DESTDIR=$PWD/DESTDIR install     &&
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32 &&
  rm -rf DESTDIR                        &&
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
