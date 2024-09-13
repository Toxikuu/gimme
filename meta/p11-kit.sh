NAME="p11-kit"
VERS="0.25.5"
TYPE=""
DEPS="libtasn1 nss"
LINK="https://github.com/p11-glue/p11-kit/releases/download/$VERS/p11-kit-$VERS.tar.xz"

get() {
  sed '20,$ d' -i trust/trust-extract-compat &&

  cat >> trust/trust-extract-compat << "EOF"
  # Copy existing anchor modifications to /etc/ssl/local
  /usr/libexec/make-ca/copy-trust-modifications

  # Update trust stores
  /usr/sbin/make-ca -r
EOF

  mkdir p11-build &&
  cd    p11-build &&

  meson setup ..            \
        --prefix=/usr       \
        --buildtype=release \
        -Dtrust_paths=/etc/pki/anchors &&
  ninja
  ninja install &&
  ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
          /usr/bin/update-ca-certificates

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"                     \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig             \
  CFLAGS+=" -Wno-error=incompatible-pointer-types" \
  meson setup ..                                   \
        --prefix=/usr                              \
        --libdir=/usr/lib32                        \
        --buildtype=release                        \
        -Dtrust_paths=/etc/pki/anchors &&

  ninja

  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig

  ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
  ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib32/libnssckbi.so
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
