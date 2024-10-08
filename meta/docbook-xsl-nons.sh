NAME="docbook-xsl-nons"
VERS="1.79.2"
TYPE="extra"
DEPS="libxml2"
LINK="https://github.com/docbook/xslt10-stylesheets/releases/download/release/$VERS/docbook-xsl-nons-$VERS.tar.bz2"

get() {
  wget https://www.linuxfromscratch.org/patches/blfs/svn/docbook-xsl-nons-$VERS-stack_fix-1.patch
  patch -Np1 -i ./docbook-xsl-nons-$VERS-stack_fix-1.patch

  install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-$VERS &&

  cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
           highlighting html htmlhelp images javahelp lib manpages params  \
           profiling roundtrip slides template tests tools webhelp website \
           xhtml xhtml-1_1 xhtml5                                          \
      /usr/share/xml/docbook/xsl-stylesheets-nons-$VERS &&

  ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-$VERS/VERSION.xsl &&

  install -v -m644 -D README \
                      /usr/share/doc/docbook-xsl-nons-$VERS/README.txt &&
  install -v -m644    RELEASE-NOTES* NEWS* \
                      /usr/share/doc/docbook-xsl-nons-$VERS

  sed -i '/rewrite/d' /etc/xml/catalog

  if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
  if [ ! -f /etc/xml/catalog ]; then
      xmlcatalog --noout --create /etc/xml/catalog
  fi &&

  xmlcatalog --noout --add "rewriteSystem" \
             "http://cdn.docbook.org/release/xsl-nons/$VERS" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteSystem" \
             "https://cdn.docbook.org/release/xsl-nons/$VERS" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteURI" \
             "http://cdn.docbook.org/release/xsl-nons/$VERS" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteURI" \
             "https://cdn.docbook.org/release/xsl-nons/$VERS" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteSystem" \
             "http://cdn.docbook.org/release/xsl-nons/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteSystem" \
             "https://cdn.docbook.org/release/xsl-nons/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteURI" \
             "http://cdn.docbook.org/release/xsl-nons/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteURI" \
             "https://cdn.docbook.org/release/xsl-nons/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteSystem" \
             "http://docbook.sourceforge.net/release/xsl/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog &&

  xmlcatalog --noout --add "rewriteURI" \
             "http://docbook.sourceforge.net/release/xsl/current" \
             "/usr/share/xml/docbook/xsl-stylesheets-nons-$VERS" \
      /etc/xml/catalog
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
