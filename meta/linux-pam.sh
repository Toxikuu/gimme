NAME="linux-pam"
VERS="1.6.1"
TYPE="extra"
DEPS=""
LINK="https://github.com/linux-pam/linux-pam/releases/download/v$VERS/Linux-PAM-$VERS.tar.xz"

get() {
  sed -e /service_DATA/d \
      -i modules/pam_namespace/Makefile.am

  autoreconf -fi
  ./configure --prefix=/usr                        \
              --sbindir=/usr/sbin                  \
              --sysconfdir=/etc                    \
              --libdir=/usr/lib                    \
              --enable-securedir=/usr/lib/security \
              --docdir=/usr/share/doc/Linux-PAM-1.6.1 &&
  make
  install -v -m755 -d /etc/pam.d &&
  
  make install &&
  chmod -v 4755 /usr/sbin/unix_chkpwd


  install -vdm755 /etc/pam.d &&
  cat > /etc/pam.d/system-account << "EOF" &&
  # Begin /etc/pam.d/system-account

  account   required    pam_unix.so

  # End /etc/pam.d/system-account
EOF

  cat > /etc/pam.d/system-auth << "EOF" &&
  # Begin /etc/pam.d/system-auth

  auth      required    pam_unix.so

  # End /etc/pam.d/system-auth
EOF

  cat > /etc/pam.d/system-session << "EOF" &&
  # Begin /etc/pam.d/system-session

  session   required    pam_unix.so

  # End /etc/pam.d/system-session
EOF

  cat > /etc/pam.d/system-password << "EOF"
  # Begin /etc/pam.d/system-password

  # use yescrypt hash for encryption, use shadow, and try to use any
  # previously defined authentication token (chosen password) set by any
  # prior module.
  password  required    pam_unix.so       yescrypt shadow try_first_pass

  # End /etc/pam.d/system-password
EOF

  cat > /etc/pam.d/other << "EOF"
  # Begin /etc/pam.d/other

  auth        required        pam_warn.so
  auth        required        pam_deny.so
  account     required        pam_warn.so
  account     required        pam_deny.so
  password    required        pam_warn.so
  password    required        pam_deny.so
  session     required        pam_warn.so
  session     required        pam_deny.so

  # End /etc/pam.d/other
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
