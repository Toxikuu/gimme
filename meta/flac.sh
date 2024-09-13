NAME="flac"
VERS="1.4.3"
TYPE="extra"
DEPS=""
LINK="https://downloads.xiph.org/releases/flac/flac-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr                                \
              --disable-thorough-tests                     \
              --docdir=/usr/share/doc/flac-$VERS

  make
  make install
  make distclean

  CC="gcc -m32" CXX="g++ -m32"                  \
  CFLAGS="-L/usr/lib32" CXXFLAGS="-L/usr/lib32" \
  ./configure --prefix=/usr                     \
              --libdir=/usr/lib32               \
              --host=i686-pc-linux-gnu          \
              --disable-thorough-tests    
                  
  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rv /usr/bin/flac                          \
  /usr/bin/metaflac                             \
  /usr/include/FLAC*                            \
  /usr/share/doc/flac-$VERS                     \
  /usr/lib{,32}/libFLAC*
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
