NAME="util-linux"
VERS="2.40.2"
TYPE="core"
DEPS=""
LINK="https://www.kernel.org/pub/linux/utils/util-linux/v$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/util-linux-$VERS.tar.xz"

get() {
  ./configure --bindir=/usr/bin     \
              --libdir=/usr/lib     \
              --runstatedir=/run    \
              --sbindir=/usr/sbin   \
              --disable-chfn-chsh   \
              --disable-login       \
              --disable-nologin     \
              --disable-su          \
              --disable-setpriv     \
              --disable-runuser     \
              --disable-pylibmount  \
              --disable-liblastlog2 \
              --disable-static      \
              --without-python      \
              --without-systemd     \
              --without-systemdsystemunitdir        \
              ADJTIME_PATH=/var/lib/hwclock/adjtime \
              --docdir=/usr/share/doc/util-linux-2.40.2
  make && make install

  make distclean
  mv /usr/bin/ncursesw6-config{,.tmp}
  CC="gcc -m32" \
  ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
              --host=i686-pc-linux-gnu \
              --libdir=/usr/lib32      \
              --runstatedir=/run       \
              --sbindir=/usr/sbin      \
              --docdir=/usr/share/doc/util-linux-2.40.2 \
              --disable-chfn-chsh      \
              --disable-login          \
              --disable-nologin        \
              --disable-su             \
              --disable-setpriv        \
              --disable-runuser        \
              --disable-pylibmount     \
              --disable-liblastlog2    \
              --disable-static         \
              --without-python         \
              --without-systemd        \
              --without-systemdsystemunitdir
  
  mv /usr/bin/ncursesw6-config{.tmp,}
  make
  make DESTDIR=$PWD/DESTDIR install
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
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
