NAME="gawk"
VERS="5.3.0"
TYPE="core"
DEPS=""
LINK="https://ftp.gnu.org/gnu/gawk/gawk-$VERS.tar.xz"

get() {
  sed -i 's/extras//' Makefile.in
  ./configure --prefix=/usr
  make
  rm -f /usr/bin/gawk-$VERS
  make install
  ln -sv gawk.1 /usr/share/man/man1/awk.1
  mkdir -pv                                   /usr/share/doc/gawk-$VERS
  cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-$VERS
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
