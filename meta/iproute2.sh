NAME="iproute2"
VERS="6.10.0"
TYPE="core"
DEPS=""
LINK="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$VERS.tar.xz"

get() {
  sed -i /ARPD/d Makefile
  rm -fv man/man8/arpd.8
  make NETNS_RUN_DIR=/run/netns
  make SBINDIR=/usr/sbin install

  mkdir -pv             /usr/share/doc/iproute2-$VERS
  cp -v COPYING README* /usr/share/doc/iproute2-$VERS
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
