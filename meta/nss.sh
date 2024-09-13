NAME="nss"
VERS="3.104"
TYPE=""
DEPS="nspr"
LINK="https://archive.mozilla.org/pub/security/nss/releases/NSS_3_104_RTM/src/nss-$VERS.tar.gz"

get() {
  wget https://www.linuxfromscratch.org/patches/blfs/svn/nss-$VERS-standalone-1.patch &&
  patch -Np1 -i ./nss-$VERS-standalone-1.patch &&
  cp -rv nss{,32}
  cd nss &&

  make BUILD_OPT=1                    \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)

  cd ../dist                                                          &&

  install -v -m755 Linux*/lib/*.so              /usr/lib              &&
  install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&

  install -v -m755 -d                           /usr/include/nss      &&
  cp -v -RL {public,private}/nss/*              /usr/include/nss      &&

  install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&

  install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig

  cd ../nss32
  rm -rvf ../dist

  CC="gcc -m32" CXX="g++ -m32"          \
  make BUILD_OPT=1                      \
    NSPR_INCLUDE_DIR=/usr/include/nspr  \
    USE_SYSTEM_ZLIB=1                   \
    ZLIB_LIBS=-lz                       \
    NSS_ENABLE_WERROR=0                 \
  $([ -f /usr/lib32/libsqlite3.so ] && echo NSS_USE_SYSTEM_SQLITE=1)

  cd ../dist &&

  install -v -m755 Linux*/lib/*.so              /usr/lib32              &&
  install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib32              &&
  sed -i 's/lib/lib32/g' Linux*/lib/pkgconfig/nss.pc                    &&
  install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib32/pkgconfig
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
