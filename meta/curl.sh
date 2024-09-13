NAME="curl"
VERS="8.9.1"
TYPE="extra"
DEPS="libpsl"
LINK="https://curl.se/download/curl-$VERS.tar.xz"

get() {
  pushd ..
  cp -rv curl-$VERS{,32}
  popd
  ./configure --prefix=/usr                           \
              --disable-static                        \
              --with-openssl                          \
              --enable-threaded-resolver              \
              --with-ca-path=/etc/ssl/certs &&
  make
  make install &&

  rm -rf docs/examples/.deps &&

  find docs \( -name Makefile\* -o  \
               -name \*.1       -o  \
               -name \*.3       -o  \
               -name CMakeLists.txt \) -delete &&

  cp -v -R docs -T /usr/share/doc/curl-$VERS
  cd ..
  rm -rvf curl-$VERS
  cd curl-$VERS32
  CC="gcc -m32" CXX="g++ -m32"           \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig   \
  ./configure --prefix=/usr              \
              --libdir=/usr/lib32        \
              --host=i686-pc-linux-gnu   \
              --disable-static           \
              --with-openssl             \
              --enable-threaded-resolver \
              --with-ca-path=/etc/ssl/certs &&

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig

  cd ..
  rm -rvf curl-$VERS32
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
