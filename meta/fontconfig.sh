NAME="fontconfig"
VERS="2.15.0"
TYPE="extra"
DEPS="freetype"
LINK="https://www.freedesktop.org/software/fontconfig/release/fontconfig-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr        \
              --sysconfdir=/etc    \
              --localstatedir=/var \
              --disable-docs       \
              --docdir=/usr/share/doc/fontconfig-$VERS &&
  make &&
  make install

  make distclean
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --sysconfdir=/etc        \
              --localstatedir=/var     \
              --host=i686-pc-linux-gnu \
              --disable-docs

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
