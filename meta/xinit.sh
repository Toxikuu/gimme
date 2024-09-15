NAME="xinit"
VERS="1.4.2"
TYPE="extra"
DEPS="xorg-libraries"
LINK="https://www.x.org/pub/individual/app/xinit-$VERS.tar.xz"

get() {
  ./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults &&
  make &&
  make install &&
  ldconfig

  nvidia-xconfig
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
