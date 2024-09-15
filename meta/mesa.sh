NAME="mesa"
VERS="24.2.2"
TYPE="extra"
DEPS="xorg-libraries libdrm mako pyyaml cbindgen rust-bindgen rustc glslang libclc libglvnd libva libvdpau llvm ply vulkan-loader wayland-protocols"
LINK="https://mesa.freedesktop.org/archive/mesa-$VERS.tar.xz"

get() {
  mkdir build &&
  cd    build &&

  meson setup ..                     \
        --prefix=$XORG_PREFIX        \
        --buildtype=release          \
        -D osmesa=true               \
        -D platforms=x11             \
        -D gallium-drivers=llvmpipe  \
        -D vulkan-drivers=""         \
        -D valgrind=disabled         \
        -D libunwind=disabled       &&

  ninja && ninja install

  rm -rf *
  CC="gcc -m32" CXX="g++ -m32"                 \
  PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
  meson setup                                  \
        --prefix=$XORG_PREFIX                  \
        --libdir=$XORG_PREFIX/lib32            \
        --buildtype=release                    \
        -D osmesa=true                         \
        -D platforms=x11                       \
        -D gallium-drivers=llvmpipe            \
        -D vulkan-drivers=""                   \
        -D valgrind=disabled                   \
        -D libunwind=disabled                  \
        -D glvnd=enabled                       \
        .. &&
        sed -i 's/\/usr\/lib\//\/usr\/lib32\//g' ./build.ninja &&

  ninja

  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
  cp -vr DESTDIR/$XORG_PREFIX/share/vulkan/* $XORG_PREFIX/share/vulkan
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
