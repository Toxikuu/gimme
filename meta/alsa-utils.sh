NAME="alsa-utils"
VERS="1.2.12"
TYPE="extra"
DEPS="alsa-lib"
LINK="https://www.alsa-project.org/files/pub/utils/alsa-utils-$VERS.tar.bz2"

get() {
  ./configure --disable-alsaconf \
              --disable-bat      \
              --disable-xmlto    \
              --with-curses=ncursesw &&
  make
  make install
  
  alsactl init || true
  alsactl -L store

  cat > /etc/asound.conf << "EOF"
    # Begin /etc/asound.conf

    defaults.pcm.card 1
    defaults.ctl.card 1

    # End /etc/asound.conf
  EOF
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
