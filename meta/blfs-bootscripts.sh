NAME="blfs-bootscripts"
VERS="20240416"
TYPE="extra"
DEPS=""
LINK="https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-$VERS.tar.xz"

get() {
  make install-service-dhcpcd
  make install-dbus
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
