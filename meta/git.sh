NAME="git"
VERS="2.46.0"
TYPE="extra"
DEPS=""
LINK="https://www.kernel.org/pub/software/scm/git/git-$VERS.tar.xz"

get() {
  ./configure --prefix=/usr \
              --with-gitconfig=/etc/gitconfig \
              --with-python=python3 &&
  make
  make perllibdir=/usr/lib/perl5/5.38/site_perl install
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
