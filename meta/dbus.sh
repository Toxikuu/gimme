NAME="dbus"
VERS="1.14.10"
TYPE="extra"
DEPS="xorg-libraries"
LINK="https://dbus.freedesktop.org/releases/dbus/dbus-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr                        \
              --sysconfdir=/etc                    \
              --localstatedir=/var                 \
              --runstatedir=/run                   \
              --disable-doxygen-docs               \
              --disable-xml-docs                   \
              --disable-static                     \
              --with-systemduserunitdir=no         \
              --with-systemdsystemunitdir=no       \
              --docdir=/usr/share/doc/dbus-1.14.10  \
              --with-system-socket=/run/dbus/system_bus_socket &&
  make && make install

  chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
  chmod -v      4750       /usr/libexec/dbus-daemon-launch-helper
  
  dbus-uuidgen --ensure
  ln -sfv /var/lib/dbus/machine-id /etc

  cat > /etc/dbus-1/session-local.conf << "EOF"
    <!DOCTYPE busconfig PUBLIC
     "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>

      <!-- Search for .service files in /usr/local -->
      <servicedir>/usr/local/share/dbus-1/services</servicedir>

    </busconfig>
EOF

  wget https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20240416.tar.xz &&
  cd blfs-bootscripts-20240416
  make install-dbus
  cd ..
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
