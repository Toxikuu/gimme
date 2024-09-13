NAME="sysklogd"
VERS="2.6.1"
TYPE="core"
DEPS=""
LINK="https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v$VERS/e2fsprogs-$VERS.tar.gz"

get() {
  ./configure --prefix=/usr      \
              --sysconfdir=/etc  \
              --runstatedir=/run \
              --without-logger
  make && make install

  cat > /etc/syslog.conf << "EOF"
  # Begin /etc/syslog.conf

  auth,authpriv.* -/var/log/auth.log
  *.*;auth,authpriv.none -/var/log/sys.log
  daemon.* -/var/log/daemon.log
  kern.* -/var/log/kern.log
  mail.* -/var/log/mail.log
  user.* -/var/log/user.log
  *.emerg *

  # Do not open any internet ports.
  secure_mode 2

  # End /etc/syslog.conf
  EOF
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
