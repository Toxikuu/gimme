NAME="libxkbcommon"
VERS="1.7.0"
TYPE="extra"
DEPS="xkeyboard-config libxcb wayland wayland-protocols"
LINK=""

get() {
  mkdir -pv build &&
  cd        build &&

  meson setup ..                       \
      --prefix=/usr                    \
      --buildtype=release              \
      -D enable-wayland=false          \
      -D enable-docs=false            &&

  ninja && ninja install

  rg -rf *
  CC="gcc -m32" CXX="g++ -m32"         \
  PKG_CONFIG_PATH=/usr/lib32/pkgconfig \
  meson setup ..                       \
        --prefix=/usr                  \
        --libdir=/usr/lib32            \
        --buildtype=release            \
        -D enable-wayland=false        \
        -D enable-docs=false          &&

  ninja &&
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
