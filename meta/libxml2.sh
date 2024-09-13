NAME="libxml2"
VERS="2.13.3"
TYPE="extra"
DEPS="icu"
LINK="https://download.gnome.org/sources/libxml2/$(echo $VERS | sed 's/\([0-9]\+\.[0-9]\+\)\.[0-9]\+/\1/')/libxml2-$VERS.tar.xz"

get() {
  wget https://www.linuxfromscratch.org/patches/blfs/svn/libxml2-$VERS-upstream_fix-2.patch
  patch -Np1 -i ../libxml2-$VERS-upstream_fix-2.patch
  ./configure --prefix=/usr           \
              --sysconfdir=/etc       \
              --disable-static        \
              --with-history          \
              --with-icu              \
              PYTHON=/usr/bin/python3 \
              --docdir=/usr/share/doc/libxml2-$VERS &&
  make && make install

  rm -vf /usr/lib/libxml2.la &&
  sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

  make distclean

  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --sysconfdir=/etc        \
              --disable-static         \
              --with-history           \
              --with-icu               \
              --without-python &&

  make
  make DESTDIR=$PWD/DESTDIR install     &&
  rm -vf DESTDIR/usr/lib32/libxml2.la   &&
  cp -Rv DESTDIR/usr/lib32/* /usr/lib32 &&
  rm -rf DESTDIR                        &&
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
