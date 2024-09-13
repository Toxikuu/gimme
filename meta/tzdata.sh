NAME="tzdata"
VERS="2024b"
TYPE="core"
DEPS=""
LINK=""

get() {
  wget "https://www.iana.org/time-zones/repository/releases/tzdata$VERS.tar.gz"
  tar xvf tzdata$VERS.tar.gz
  ZONEINFO=/usr/share/zoneinfo
  mkdir -pv $ZONEINFO/{posix,right}

  for tz in etcetera southamerica northamerica europe africa antarctica  \
            asia australasia backward; do
      zic -L /dev/null   -d $ZONEINFO       ${tz}
      zic -L /dev/null   -d $ZONEINFO/posix ${tz}
      zic -L leapseconds -d $ZONEINFO/right ${tz}
  done

  cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
  zic -d $ZONEINFO -p America/New_York
  unset ZONEINFO

  ln -sfv /usr/share/zoneinfo/America/Chicago /etc/localtime

  # for consistency
  mv -v tzdata*.tar.gz ../tzdata-$VERS.tar
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
