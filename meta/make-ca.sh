NAME="make-ca"
VERS="1.14"
TYPE=""
DEPS="p11-kit libtasn1 nss"
LINK="https://github.com/lfs-book/make-ca/archive/v$VERS/make-ca-$VERS.tar.gz"

get() {
  cat >> make-ca << "EOF"
  ln -svf /etc/pki/tls/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
EOF

  make install &&
  install -vdm755 /etc/ssl/local

  /usr/sbin/make-ca -g
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
