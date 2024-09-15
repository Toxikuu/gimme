NAME="alacritty"
VERS="0.13.2"
TYPE="extra"
DEPS="freetype fontconfig xorg-libraries xcb-util-cursor rustc cmake desktop-file-utils libxcb"
LINK="https://github.com/alacritty/alacritty/archive/refs/tags/v$VERS.tar.gz"

get() {
  cargo build --release --no-default-features --features=x11 &&
  infocmp alacritty &&
  tic -xe alacritty,alacritty-direct extra/alacritty.info || true &&
  cp target/release/alacritty /usr/local/bin
  cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  desktop-file-install extra/linux/Alacritty.desktop
  update-desktop-database

  mkdir -p ~/.bash_completion
  cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
  echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
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
