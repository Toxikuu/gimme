NAME="openssl"
VERS="3.3.2"
TYPE="extra"
DEPS=""
LINK="https://github.com/openssl/openssl/releases/download/openssl-$VERS/openssl-$VERS.tar.gz"

get() {
  ./config --prefix=/usr         \
           --openssldir=/etc/ssl \
           --libdir=lib          \
           shared                \
           zlib-dynamic          &&
  make &&
  sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
  make MANSUFFIX=ssl install
  mv -v /usr/share/doc/openssl /usr/share/doc/openssl-$VERS
  cp -vfr doc/* /usr/share/doc/openssl-$VERS

  make distclean
  ./config --prefix=/usr         \
         --openssldir=/etc/ssl   \
         --libdir=lib32          \
         shared                  \
         zlib-dynamic            \
         linux-x86

  make &&
  make DESTDIR=$PWD/DESTDIR install
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
}

remove() {
  rm -rv                   \
  /usr/bin/c_rehash             \
  /usr/bin/openssl              \
  /etc/ssl                      \
  /usr/include/openssl          \
  /usr/share/doc/openssl*       \
  /usr/lib{,32}/libssl.so*      \
  /usr/lib{,32}/libcrypto.so*
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
