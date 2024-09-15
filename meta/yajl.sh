NAME="yajl"
VERS="2.1.0"
TYPE="extra"
DEPS="glibc cmake"
LINK="https://github.com/lloyd/yajl/archive/refs/tags/$VERS.tar.gz"

get() {
  wget https://gitlab.archlinux.org/archlinux/packaging/packages/yajl/-/raw/main/yajl-$VERS-CVE-2017-16516.patch
  wget https://gitlab.archlinux.org/archlinux/packaging/packages/yajl/-/raw/main/yajl-$VERS-CVE-2022-24795.patch
  wget https://gitlab.archlinux.org/archlinux/packaging/packages/yajl/-/raw/main/yajl-$VERS-memory_leak.patch

  patch --verbose -Np1 -i ./yajl-$VERS-CVE-2017-16516.patch
  patch --verbose -Np1 -i ./yajl-$VERS-CVE-2022-24795.patch
  patch --verbose -Np1 -i ./yajl-$VERS-memory_leak.patch

  cmake                          \
    -B build                     \
    -D CMAKE_BUILD_TYPE=None     \
    -D CMAKE_INSTALL_PREFIX=/usr
  cmake --build build --verbose
  cmake --install build
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
