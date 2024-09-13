NAME="harfbuzz"
VERS="9.0.0"
TYPE="extra"
DEPS=""
LINK="https://github.com/harfbuzz/harfbuzz/releases/download/9.0.0/harfbuzz-9.0.0.tar.xz"

get() {
  # handle the freetype circular dependency
  # freetype pass 1
  wget https://downloads.sourceforge.net/freetype/freetype-2.13.3.tar.xz &&
  tar xvf freetype-2.13.3.tar.xz && cd freetype-2.13.3
  sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

  sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
      -i include/freetype/config/ftoption.h  &&

  ./configure --prefix=/usr --enable-freetype-config --disable-static &&
  make
  make install
  make distclean

  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  ./configure --prefix=/usr            \
              --libdir=/usr/lib32      \
              --host=i686-pc-linux-gnu \
              --enable-freetype-config \
              --disable-static

  make
  make DESTDIR=$PWD/DESTDIR install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig

  cd ..
  rm -rvf freetype-2.13.3
  
  if [ -e /usr/lib/pkgconfig/glib-2.0.pc ]; then
    mv /usr/lib/pkgconfig/{,NOUSE.}glib-2.0.pc
  fi

  mkdir build &&
  cd    build &&

  meson setup ..            \
        --prefix=/usr       \
        --buildtype=release \
        -D graphite2=disabled

  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup ..                       \
        --prefix=/usr                  \
        --libdir=/usr/lib32            \
        --buildtype=release            \
        -D graphite2=disabled

  ninja

  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig

  if [ -e /usr/lib/pkgconfig/NOUSE.glib-2.0.pc ]; then
    mv /usr/lib/pkgconfig/{NOUSE.,}glib-2.0.pc
  fi
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
