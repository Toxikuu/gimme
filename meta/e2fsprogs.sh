NAME="e2fsprogs"
VERS="1.47.1"
TYPE="core"
DEPS=""
LINK="https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v$VERS/e2fsprogs-$VERS.tar.gz"

get() {
  mkdir -v build
  cd       build

  ../configure --prefix=/usr         \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
  make
  make install
  rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

  gunzip -v /usr/share/info/libext2fs.info.gz
  install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

  makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
  install -v -m644 doc/com_err.info /usr/share/info
  install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
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
