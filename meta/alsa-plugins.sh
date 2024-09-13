NAME="alsa-plugins"
VERS="1.2.12"
TYPE="extra"
DEPS="alsa-lib"
LINK="https://www.alsa-project.org/files/pub/plugins/alsa-plugins-$VERS.tar.bz2"

get() {
  ./configure --sysconfdir=/etc --disable-libav &&
  make
  make install

  make distclean
  CC="gcc -m32" CXX="g++ -m32"                  \
  ./configure --prefix=/usr --libdir=/usr/lib32 \
              --sysconfdir=/etc --disable-libav \
              --host=i686-pc-linux-gnu

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig
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
