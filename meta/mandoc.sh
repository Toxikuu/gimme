NAME="mandoc"
VERS="1.14.6"
TYPE="extra"
DEPS=""
LINK="http://ftp.rpm.org/popt/releases/popt-1.x/popt-$VERS.tar.gz"

get() {
  ./configure &&
  make mandoc

  install -vm755 mandoc   /usr/bin &&
  install -vm644 mandoc.1 /usr/share/man/man1
}

remove() {
  rm -v /urs/bin/mandoc /usr/share/man/man1/mandoc.1
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
