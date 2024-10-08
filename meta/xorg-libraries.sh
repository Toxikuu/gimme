NAME="xorg-libraries"
VERS="1-tox"
TYPE="extra"
DEPS="fontconfig libxcb wget"
LINK=""

get() {
  cat > lib-7-list <<EOF
    xtrans-1.5.0.tar.xz
    libX11-1.8.10.tar.xz
    libXext-1.3.6.tar.xz
    libFS-1.0.10.tar.xz
    libICE-1.1.1.tar.xz
    libSM-1.2.4.tar.xz
    libXScrnSaver-1.2.4.tar.xz
    libXt-1.3.0.tar.xz
    libXmu-1.2.1.tar.xz
    libXpm-3.5.17.tar.xz
    libXaw-1.0.16.tar.xz
    libXfixes-6.0.1.tar.xz
    libXcomposite-0.4.6.tar.xz
    libXrender-0.9.11.tar.xz
    libXcursor-1.2.2.tar.xz
    libXdamage-1.1.6.tar.xz
    libfontenc-1.1.8.tar.xz
    libXfont2-2.0.7.tar.xz
    libXft-2.3.8.tar.xz
    libXi-1.8.1.tar.xz
    libXinerama-1.1.5.tar.xz
    libXrandr-1.5.4.tar.xz
    libXres-1.2.2.tar.xz
    libXtst-1.2.5.tar.xz
    libXv-1.0.12.tar.xz
    libXvMC-1.0.14.tar.xz
    libXxf86dga-1.1.6.tar.xz
    libXxf86vm-1.1.5.tar.xz
    libpciaccess-0.18.1.tar.xz
    libxkbfile-1.1.3.tar.xz
    libxshmfence-1.3.2.tar.xz
    libXpresent-1.0.1.tar.xz
EOF

  mkdir lib &&
  cd lib &&
  grep -v '^#' ../lib-7-list | wget -i- -c \
      -B https://www.x.org/pub/individual/lib/

  ### 64 bit
  for package in $(grep -v '^#' ../lib-7-list)
  do
    packagedir=${package%.tar.?z*}
    echo "Building $packagedir"

    tar -xf $package
    pushd $packagedir
    docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
    
    case $packagedir in
      libXfont2-[0-9]* )
        ./configure $XORG_CONFIG $docdir --disable-devel-docs
      ;;

      libXt-[0-9]* )
        ./configure $XORG_CONFIG $docdir \
                    --with-appdefaultdir=/etc/X11/app-defaults
      ;;

      libXpm-[0-9]* )
        ./configure $XORG_CONFIG $docdir --disable-open-zfile
      ;;
    
      libpciaccess* )
        mkdir build
        cd    build
          meson setup --prefix=$XORG_PREFIX --buildtype=release ..
          ninja
          #ninja test
          ninja install
        popd     # $packagedir
        rm -rf $packagedir
        continue # for loop
      ;;

      * )
        ./configure $XORG_CONFIG $docdir
      ;;
    esac

    make
    #make check 2>&1 | tee ../$packagedir-make_check.log
    make install
    popd
    rm -rf $packagedir
    /sbin/ldconfig
  done


  ### 32 bit
  for package in $(grep -v '^#' ../lib-7-list)
  do
    packagedir=${package%.tar.?z*}
    echo "Building lib32-$packagedir"

    tar -xf $package
    pushd $packagedir
    libdir="--libdir=$XORG_PREFIX/lib32"
    docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
    host="--host=i686-pc-linux-gnu"
    
    case $packagedir in
      libXfont2-[0-9]* )
        CC="gcc -m32" CXX="g++ -m32" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig  \
        ./configure $XORG_CONFIG $libdir $host $docdir --disable-devel-docs
      ;;

      libXt-[0-9]* )
        CC="gcc -m32" CXX="g++ -m32" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
        ./configure $XORG_CONFIG $libdir $host $docdir                    \
                    --with-appdefaultdir=/etc/X11/app-defaults
      ;;

      libXpm-[0-9]* )
        CC="gcc -m32" CXX="g++ -m32" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig  \
        ./configure $XORG_CONFIG $libdir $host $docdir --disable-open-zfile
      ;;
    
      libpciaccess* )
        mkdir build
        cd    build
          CC="gcc -m32" CXX="g++ -m32" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
          meson setup --prefix=$XORG_PREFIX $libdir --buildtype=release ..
          ninja
          #ninja test
          DESTDIR=$PWD/DESTDIR ninja install
          cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
          rm -rf DESTDIR
          /sbin/ldconfig
        popd     # $packagedir
        rm -rf $packagedir
        continue # for loop
      ;;

      xtrans* )
          CC="gcc -m32" CXX="g++ -m32" PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig \
          ./configure $XORG_CONFIG $libdir $host $docdir
          make
          make DESTDIR=$PWD/DESTDIR install
          cp -vr DESTDIR/$XORG_PREFIX/share/pkgconfig/* $XORG_PREFIX/lib32/pkgconfig
          rm -rf DESTDIR
        popd
        rm -rf $packagedir
        continue
      ;;

      * )
        CC="gcc -m32" CXX="g++ -m32"                   \
        PKG_CONFIG_PATH=$XORG_PREFIX/lib32/pkgconfig   \
        ./configure $XORG_CONFIG $libdir $host $docdir
      ;;
    esac

    make
    #make check 2>&1 | tee ../$packagedir-make_check.log
    make DESTDIR=$PWD/DESTDIR install
    cp -vr DESTDIR/$XORG_PREFIX/lib32/* $XORG_PREFIX/lib32
    rm -rf DESTDIR
    popd
    rm -rf $packagedir
    /sbin/ldconfig
  done

  # TODO: Make a tar archive of all of these packages and copy it to src/ for consistency
  # Also note, the commands for XORG_PREFIX != /usr aren't implemented here
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
