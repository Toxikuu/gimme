NAME="dhcpcd"
VERS="10.0.10"
TYPE="extra"
DEPS=""
LINK="https://github.com/NetworkConfiguration/dhcpcd/releases/download/v$VERS/dhcpcd-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr              \
            --sysconfdir=/etc            \
            --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd      \
            --runstatedir=/run           \
            --disable-privsep            &&
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
