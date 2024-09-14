NAME="polkit"
VERS="125"
TYPE="extra"
DEPS="duktape glib-no-gobject linux-pam elogind"
LINK="https://github.com/polkit-org/polkit/archive/$VERS/polkit-$VERS.tar.gz"

get() {
  groupadd -fg 27 polkitd &&
  useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
          -g polkitd -s /bin/false polkitd

  sed -i '/systemd_sysusers_dir/s/^/#/' meson.build

  mkdir build &&
  cd    build &&

  meson setup ..                    \
        --prefix=/usr               \
        --buildtype=release         \
        -D man=false                \
        -D session_tracking=elogind \
        -D introspection=false      \
        -D tests=false

  ninja && ninja install
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
