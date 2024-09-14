NAME="elogind"
VERS="255.5"
TYPE="extra"
DEPS="dbus linux-pam"
LINK="https://github.com/elogind/elogind/archive/v$VERS/elogind-$VERS.tar.gz"

get() {
  mkdir build &&
  cd    build &&

  meson setup ..                               \
        --prefix=/usr                          \
        --buildtype=release                    \
        -D docdir=/usr/share/doc/elogind-255.5 \
        -D cgroup-controller=elogind           \
        -D dev-kvm-mode=0660                   \
        -D dbuspolicydir=/etc/dbus-1/system.d &&
  ninja

  ninja install                                           &&
  ln -sfv  libelogind.pc /usr/lib/pkgconfig/libsystemd.pc &&
  ln -sfvn elogind /usr/include/systemd

  sed -e '/\[Login\]/a KillUserProcesses=no' \
      -i /etc/elogind/logind.conf

  cat >> /etc/pam.d/system-session << "EOF" &&
  # Begin elogind addition

  session  required    pam_loginuid.so
  session  optional    pam_elogind.so

  # End elogind addition
EOF
  cat > /etc/pam.d/elogind-user << "EOF"
  # Begin /etc/pam.d/elogind-user

  account  required    pam_access.so
  account  include     system-account

  session  required    pam_env.so
  session  required    pam_limits.so
  session  required    pam_unix.so
  session  required    pam_loginuid.so
  session  optional    pam_keyinit.so force revoke
  session  optional    pam_elogind.so

  auth     required    pam_deny.so
  password required    pam_deny.so

  # End /etc/pam.d/elogind-user
EOF

  echo "You may want to try rebooting and running loginctl"
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
