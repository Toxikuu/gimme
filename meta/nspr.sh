NAME="nspr"
VERS="4.35"
TYPE=""
DEPS=""
LINK="https://archive.mozilla.org/pub/nspr/releases/v$VERS/src/nspr-$VERS.tar.gz"

get() {
  cd nspr &&

  sed -i '/^RELEASE/s|^|#|' pr/src/misc/Makefile.in &&
  sed -i 's|$(LIBRARY) ||'  config/rules.mk         &&

  ./configure --prefix=/usr   \
              --with-mozilla  \
              --with-pthreads \
              $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
  make && make install

  make distclean
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --with-mozilla           \
              --with-pthreads          \
              --disable-64bit &&
  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
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
