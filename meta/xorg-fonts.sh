NAME="xorg-fonts"
VERS="1-tox"
TYPE="extra"
DEPS="xcursor-themes"
LINK=""

get() {
  cat > font-7-list << "EOF"
  font-util-1.4.1.tar.xz
  encodings-1.1.0.tar.xz
  font-alias-1.0.5.tar.xz
  font-adobe-utopia-type1-1.0.5.tar.xz
  font-bh-ttf-1.0.4.tar.xz
  font-bh-type1-1.0.4.tar.xz
  font-ibm-type1-1.0.4.tar.xz
  font-misc-ethiopic-1.0.5.tar.xz
  font-xfree86-type1-1.0.5.tar.xz
EOF

  mkdir font &&
  cd font &&
  grep -v '^#' ../font-7-list | wget -i- -c \
      -B https://www.x.org/pub/individual/font/

  for package in $(grep -v '^#' ../font-7-list)
  do
    packagedir=${package%.tar.?z*}
    tar -xf $package
    pushd $packagedir
      ./configure $XORG_CONFIG
      make
      make install
    popd
    rm -rf $packagedir
  done

  install -v -d -m755 /usr/share/fonts
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
