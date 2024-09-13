NAME="libpipeline"
VERS="1.5.8"
TYPE="core"
DEPS=""
LINK="https://download.savannah.gnu.org/releases/libpipeline/libpipeline-.tar.gz"

get() {
  ./configure --prefix=/usr &&
  make &&
  make install
}

remove() {
  rm -v /usr/lib/libpipeline.so* \
  /usr/include/pipeline.h             \
  /usr/share/man/man3/libpipeline.3   \
  /usr/share/man/man3/pipeline_*      \
  /usr/share/man/man3/pipecmd_*
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
