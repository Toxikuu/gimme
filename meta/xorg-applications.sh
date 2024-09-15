NAME="xorg-applications"
VERS="1-tox"
TYPE="extra"
DEPS="libpng mesa xbitmaps xcb-util"
LINK=""

get() {
    cat > app-7-list << "EOF"
  iceauth-1.0.10.tar.xz
  mkfontscale-1.2.3.tar.xz
  sessreg-1.1.3.tar.xz
  setxkbmap-1.3.4.tar.xz
  smproxy-1.0.7.tar.xz
  x11perf-1.6.1.tar.bz2
  xauth-1.1.3.tar.xz
  xcmsdb-1.0.6.tar.xz
  xcursorgen-1.0.8.tar.xz
  xdpyinfo-1.3.4.tar.xz
  xdriinfo-1.0.7.tar.xz
  xev-1.2.6.tar.xz
  xgamma-1.0.7.tar.xz
  xhost-1.0.9.tar.xz
  xinput-1.6.4.tar.xz
  xkbcomp-1.4.7.tar.xz
  xkbevd-1.1.5.tar.xz
  xkbutils-1.0.6.tar.xz
  xkill-1.0.6.tar.xz
  xlsatoms-1.1.4.tar.xz
  xlsclients-1.1.5.tar.xz
  xmessage-1.0.7.tar.xz
  xmodmap-1.0.11.tar.xz
  xpr-1.2.0.tar.xz
  xprop-1.2.7.tar.xz
  xrandr-1.5.2.tar.xz
  xrdb-1.2.2.tar.xz
  xrefresh-1.1.0.tar.xz
  xset-1.2.5.tar.xz
  xsetroot-1.1.3.tar.xz
  xvinfo-1.1.5.tar.xz
  xwd-1.0.9.tar.xz
  xwininfo-1.1.6.tar.xz
  xwud-1.0.6.tar.xz
EOF

  mkdir app &&
  cd app &&
  grep -v '^#' ../app-7-list | wget -i- -c \
      -B https://www.x.org/pub/individual/app/

  for package in $(grep -v '^#' ../app-7-list)
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

  rm -vf $XORG_PREFIX/bin/xkeystone
  cd ..
  tar cpvf xorg-applications.tar app
  mv xorg-applications.tar ../
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
