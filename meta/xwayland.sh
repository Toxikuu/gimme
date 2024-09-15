NAME="xwayland"
VERS="24.1.2"
TYPE="extra"
DEPS="libxcvt pixman wayland-protocols xorg-applications xorg-fonts libepoxy mesa"
LINK="https://www.x.org/pub/individual/xserver/xwayland-$VERS.tar.xz"

get() {
  sed -i '/install_man/,$d' meson.build &&
  mkdir build &&
  cd    build &&

  meson setup --prefix=$XORG_PREFIX          \
              --buildtype=release            \
              -D xkb_output_dir=/var/lib/xkb \
              -D secure-rpc=false            \
              .. &&

  ninja
  ninja install &&
  cat >> /etc/sysconfig/createfiles << "EOF"
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
