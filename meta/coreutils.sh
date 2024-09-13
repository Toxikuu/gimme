NAME="coreutils"
VERS="9.5"
TYPE="extra"
DEPS=""
LINK="https://ftp.gnu.org/gnu/coreutils/coreutils-$VERS.tar.xz"

get() {
  wget https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.5-i18n-2.patch
  patch -Np1 -i ./coreutils-9.5-i18n-2.patch

  autoreconf -fiv
  FORCE_UNSAFE_CONFIGURE=1 ./configure \
              --prefix=/usr            \
              --enable-no-install-program=kill,uptime
  make
  make install
  mv -v /usr/bin/chroot /usr/sbin
  mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
  sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
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
