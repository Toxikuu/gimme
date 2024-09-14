NAME="gnutls"
VERS="3.8.7.1"
TYPE="extra"
DEPS="nettle make-ca libunistring libtasn1 p11-kit"
LINK="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr \
              --docdir=/usr/share/doc/gnutls-$VERS \
              --with-default-trust-store-pkcs11="pkcs11:" &&
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
