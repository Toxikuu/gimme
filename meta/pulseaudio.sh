NAME="pulseaudio"
VERS="17.0"
TYPE="extra"
DEPS="libsndfile alsa-lib"
LINK="https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup --prefix=/usr       \
              --buildtype=release \
              -D database=gdbm    \
              -D doxygen=false    \
              -D bluez5=disabled  \
              .. &&
  ninja
  ninja install
  rm /usr/share/dbus-1/system.d/pulseaudio-system.conf
  rm -rf *

  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup --prefix=/usr            \
              --libdir=/usr/lib32      \
              --buildtype=release      \
              -D database=gdbm         \
              -D doxygen=false         \
              -D bluez5=disabled       \
              ..

  ninja
  DESTDIR=$PWD/DESTDIR ninja install
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
