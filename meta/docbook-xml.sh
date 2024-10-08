NAME="docbook-xml"
VERS="4.5"
TYPE="extra"
DEPS="libxml2 unzip"
LINK="https://www.docbook.org/xml/$VERS/docbook-xml-$VERS.zip"

get() {
  install -v -d -m755 /usr/share/xml/docbook/xml-dtd-$VERS &&
  install -v -d -m755 /etc/xml &&
  cp -v -af --no-preserve=ownership docbook.cat *.dtd ent/ *.mod \
      /usr/share/xml/docbook/xml-dtd-$VERS

  if [ ! -e /etc/xml/docbook ]; then
    xmlcatalog --noout --create /etc/xml/docbook
  fi &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//DTD DocBook XML V$VERS//EN" \
      "http://www.oasis-open.org/docbook/xml/$VERS/docbookx.dtd" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//DTD DocBook XML CALS Table Model V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/calstblx.dtd" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/soextblx.dtd" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ELEMENTS DocBook XML Information Pool V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/dbpoolx.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/dbhierx.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ELEMENTS DocBook XML HTML Tables V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/htmltblx.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ENTITIES DocBook XML Notations V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/dbnotnx.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ENTITIES DocBook XML Character Entities V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/dbcentx.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "public" \
      "-//OASIS//ENTITIES DocBook XML Additional General Entities V$VERS//EN" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS/dbgenent.mod" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "rewriteSystem" \
      "http://www.oasis-open.org/docbook/xml/$VERS" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS" \
      /etc/xml/docbook &&
  xmlcatalog --noout --add "rewriteURI" \
      "http://www.oasis-open.org/docbook/xml/$VERS" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS" \
      /etc/xml/docbook

  if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
  fi &&
  xmlcatalog --noout --add "delegatePublic" \
      "-//OASIS//ENTITIES DocBook XML" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog &&
  xmlcatalog --noout --add "delegatePublic" \
      "-//OASIS//DTD DocBook XML" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog &&
  xmlcatalog --noout --add "delegateSystem" \
      "http://www.oasis-open.org/docbook/" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog &&
  xmlcatalog --noout --add "delegateURI" \
      "http://www.oasis-open.org/docbook/" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog

  for DTDVERSION in 4.1.2 4.2 4.3 4.4
  do
    xmlcatalog --noout --add "public" \
      "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
      "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
      /etc/xml/docbook
    xmlcatalog --noout --add "rewriteSystem" \
      "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS" \
      /etc/xml/docbook
    xmlcatalog --noout --add "rewriteURI" \
      "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
      "file:///usr/share/xml/docbook/xml-dtd-$VERS" \
      /etc/xml/docbook
    xmlcatalog --noout --add "delegateSystem" \
      "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog
    xmlcatalog --noout --add "delegateURI" \
      "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
      "file:///etc/xml/docbook" \
      /etc/xml/catalog
  done
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
