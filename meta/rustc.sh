NAME="rustc"
VERS="1.81.0"
TYPE="extra"
DEPS="cmake curl llvm"
LINK="https://static.rust-lang.org/dist/rustc-$VERS-src.tar.xz"

get() {
  mkdir -pv /opt/rustc-1.81.0      &&
  ln -svfn rustc-1.81.0 /opt/rustc

  cat << EOF > config.toml
  # see config.toml.example for more possible options.
  # Tell x.py the editors have reviewed the content of this file
  # and updated it to follow the major changes of the building system,
  # so x.py will not warn us to do such a review.
  change-id = 127866

  [llvm]
  # When using system llvm prefer shared libraries
  link-shared = true

  [build]
  # Enable which targets to build.
  target = [
    "x86_64-unknown-linux-gnu",
    "i686-unknown-linux-gnu",
  ]

  # omit docs to save time and space (default is to build them)
  docs = false

  # install extended tools: cargo, clippy, etc
  extended = true

  # Do not query new versions of dependencies online.
  locked-deps = true

  # Specify which extended tools (those from the default install).
  tools = ["cargo", "clippy", "rustdoc", "rustfmt"]

  # Use the source code shipped in the tarball for the dependencies.
  # The combination of this and the "locked-deps" entry avoids downloading
  # many crates from Internet, and makes the Rustc build more stable.
  vendor = true

  [install]
  prefix = "/opt/rustc-$VERS"
  docdir = "share/doc/rustc-$VERS"

  [rust]
  channel = "stable"
  description = "for GLFS 8f42"

  # Uncomment if FileCheck has been installed.
  #codegen-tests = false

  # Enable the same optimizations as the official upstream build.
  lto = "thin"
  codegen-units = 1

  [target.x86_64-unknown-linux-gnu]
  cc = "/usr/bin/gcc"
  cxx = "/usr/bin/g++"
  ar = "/usr/bin/gcc-ar"
  ranlib = "/usr/bin/gcc-ranlib"
  llvm-config = "/usr/bin/llvm-config"

  [target.i686-unknown-linux-gnu]
  cc = "/usr/bin/gcc"
  cxx = "/usr/bin/g++"
  ar = "/usr/bin/gcc-ar"
  ranlib = "/usr/bin/gcc-ranlib"
EOF

  python3 x.py build
  python3 x.py install rustc std &&
  python3 x.py install --stage=1 cargo clippy rustfmt

  rm -fv /opt/rustc-$VERS/share/doc/rustc-$VERS/*.old   &&
  install -vm644 README.md                                \
                 /opt/rustc-1.81.0/share/doc/rustc-$VERS &&

  install -vdm755 /usr/share/zsh/site-functions      &&
  ln -sfv /opt/rustc/share/zsh/site-functions/_cargo \
          /usr/share/zsh/site-functions

  echo "pathprepend /opt/rustc/bin " >> /etc/profile
  . /etc/profile
  echo "You may want to source /etc/profile"
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
