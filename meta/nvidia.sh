NAME="nvidia"
VERS="560.35.03"
TYPE="extra"
DEPS="xorg-libraries libglvnd vulkan-loader wayland"
LINK=""

get() {
  wget https://us.download.nvidia.com/XFree86/Linux-x86_64/$VERS/NVIDIA-Linux-x86_64-$VERS.run
  sudo sh ./NVIDIA-Linux-x86_64-$VERS.run   \
    --silent                                \
    --no-rpms                               \
    --no-recursion                          \
    --no-x-check                            \
    --no-nouveau-check                      \
    --disable-nouveau                       \
    --run-nvidia-xconfig                    \
    --force-selinux=no                      \
    --no-peermem                            \
    --no-systemd                            \
    --kernel-module-type=proprietary        \
    --no-rebuild-initramfs                  \
    --allow-installation-with-running-driver 
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
