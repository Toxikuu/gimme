NAME="pcre2"
VERS="10.44"
TYPE="extra"
DEPS=""
LINK="https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$VERS/pcre2-$VERS.tar.bz2"

get() {
  ./configure --prefix=/usr                       \
              --docdir=/usr/share/doc/pcre2-10.44 \
              --enable-unicode                    \
              --enable-jit                        \
              --enable-pcre2-16                   \
              --enable-pcre2-32                   \
              --enable-pcre2grep-libz             \
              --enable-pcre2grep-libbz2           \
              --enable-pcre2test-libreadline      \
              --disable-static                    &&
  make &&
  make install
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
