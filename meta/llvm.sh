NAME="llvm"
VERS="18.1.7"
TYPE="extra"
DEPS="cmake"
LINK="https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERS/llvm-$VERS.src.tar.xz"

get() {
  pushd ..
  wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-18.src.tar.xz
  wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-18.src.tar.xz
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERS/clang-$VERS.src.tar.xz
  popd

  tar -xf ../llvm-cmake-18.src.tar.xz                                   &&
  tar -xf ../llvm-third-party-18.src.tar.xz                             &&
  sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@llvm-cmake-18.src@'          \
      -i CMakeLists.txt                                                 &&
  sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@llvm-third-party-18.src@' \
      -i cmake/modules/HandleLLVMOptions.cmake

  tar -xf ../clang-$VERS.src.tar.xz -C tools &&
  mv tools/clang-$VERS.src tools/clang

  grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'

  mkdir -v build &&
  cd       build &&

  CC=gcc CXX=g++                                   \
  cmake -D CMAKE_INSTALL_PREFIX=/usr               \
        -D CMAKE_SKIP_INSTALL_RPATH=ON             \
        -D LLVM_ENABLE_FFI=ON                      \
        -D CMAKE_BUILD_TYPE=Release                \
        -D LLVM_BUILD_LLVM_DYLIB=ON                \
        -D LLVM_LINK_LLVM_DYLIB=ON                 \
        -D LLVM_ENABLE_RTTI=ON                     \
        -D LLVM_TARGETS_TO_BUILD="X86;host"        \
        -D LLVM_BINUTILS_INCDIR=/usr/include       \
        -D LLVM_INCLUDE_BENCHMARKS=OFF             \
        -D CLANG_DEFAULT_PIE_ON_LINUX=ON           \
        -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
        -W no-dev -G Ninja .. &&

  ninja

  ninja install &&
  cp bin/FileCheck /usr/bin
  rm -rf *

  CC=gcc CXX=g++                                          \
  cmake -D CMAKE_INSTALL_PREFIX=/usr                      \
        -D CMAKE_C_FLAGS:STRING=-m32                      \
        -D CMAKE_SKIP_INSTALL_RPATH=ON                    \
        -D CMAKE_CXX_FLAGS:STRING=-m32                    \
        -D LLVM_TARGET_ARCH:STRING=i686                   \
        -D LLVM_LIBDIR_SUFFIX=32                          \
        -D LLVM_ENABLE_FFI=ON                             \
        -D CMAKE_BUILD_TYPE=Release                       \
        -D LLVM_BUILD_LLVM_DYLIB=ON                       \
        -D LLVM_LINK_LLVM_DYLIB=ON                        \
        -D LLVM_ENABLE_RTTI=ON                            \
        -D LLVM_DEFAULT_TARGET_TRIPLE="i686-pc-linux-gnu" \
        -D LLVM_TARGETS_TO_BUILD="X86;host"               \
        -D LLVM_HOST_TRIPLE="x86_64-pc-linux-gnu"         \
        -D LLVM_BINUTILS_INCDIR=/usr/include              \
        -D LLVM_INCLUDE_BENCHMARKS=OFF                    \
        -D CLANG_DEFAULT_PIE_ON_LINUX=ON                  \
        -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang        \
        -W no-dev -G Ninja .. &&

  ninja
  DESTDIR=$PWD/DESTDIR ninja install
  cp -vr DESTDIR/usr/lib32/* /usr/lib32
  rm -rf DESTDIR
  ldconfig

  mkdir -pv /etc/clang &&
  for i in clang clang++; do
    echo -fstack-protector-strong > /etc/clang/$i.cfg
  done
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
