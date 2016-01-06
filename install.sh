#!/usr/bin/env sh

THIS_DIR=$(cd $(dirname $0); pwd)
LUAROCKS_VERSION="2.2.2"
LUAROCKS_DIR="$THIS_DIR/luarocks"

# Will install luarocks in $LUAROCKS_DIR with version $LUAROCKS_VERSION
install_luarocks() {
  curl "http://keplerproject.github.io/luarocks/releases/luarocks-$LUAROCKS_VERSION.tar.gz"\
    -L | tar zxf - || exit

  cd "luarocks-$LUAROCKS_VERSION" || exit
  ./configure --prefix="$LUAROCKS_DIR" --sysconfdir="$LUAROCKS_DIR/luarocks" \
    --force-config || exit

  make build || exit
  make install || exit
  cd ..
  rm -rf "luarocks-$LUAROCKS_VERSION"
}

install_luarocks_packages() {
  "$LUAROCKS_DIR/bin/luarocks" install luasec || exit
  "$LUAROCKS_DIR/bin/luarocks" install moonscript || exit
  "$LUAROCKS_DIR/bin/luarocks" install lualogging || exit
  "$LUAROCKS_DIR/bin/luarocks" install luafilesystem || exit
}

install_luarocks $LUAROCKS_VERSION $LUAROCKS_DIR
install_luarocks_packages
