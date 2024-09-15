NAME="xorg-server"
VERS="21.1.13"
TYPE="extra"
DEPS="libxcvt pixman xorg-fonts xkeyboard-config dbus elogind libepoxy"
LINK="https://www.x.org/pub/individual/xserver/xorg-server-21.1.13.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup ..              \
        --prefix=$XORG_PREFIX \
        --localstatedir=/var  \
        -D glamor=true        \
        -D secure-rpc=false   \
        -D xkb_output_dir=/var/lib/xkb &&
  ninja
  ninja install &&
  mkdir -pv /etc/X11/xorg.conf.d &&
  install -v -d -m1777 /tmp/.{ICE,X11}-unix &&
  cat >> /etc/sysconfig/createfiles << "EOF"
  /tmp/.ICE-unix dir 1777 root root
  /tmp/.X11-unix dir 1777 root root
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
