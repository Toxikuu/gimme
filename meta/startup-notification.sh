NAME="startup-notification"
VERS="0.12"
TYPE="extra"
DEPS="xorg-libraries xcb-util"
LINK="https://www.freedesktop.org/software/startup-notification/releases/startup-notification-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr --disable-static &&
  make &&
  make install &&
  install -v -m644 -D doc/startup-notification.txt \
      /usr/share/doc/startup-notification-0.12/startup-notification.txt
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
