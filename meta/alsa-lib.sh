NAME="alsa-lib"
VERS="1.2.12"
TYPE="extra"
DEPS=""
LINK="https://www.alsa-project.org/files/pub/lib/alsa-lib-$VERS.tar.bz2"

get() {
  ./configure &&
  make

  make install
  make distclean

  CC="gcc -m32" CXX="g++ -m32"         \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig
}

remove() {
  rm -rv /usr/bin/aserver         \
  /usr/lib{,32}/libasound.so*          \
  /usr/lib{,32}/libatopology.so*       \
  /usr/include/alsa                    \
  /usr/share/alsa                      \
  /usr/share/doc/alsa-lib-$VERS
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
