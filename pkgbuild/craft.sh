#!/bin/bash

# Download
wget https://github.com/frefolli/sexpresso/archive/master.tar.gz

HASH=$(sha256sum master.tar.gz | awk '{ print $1 }')
cat header > PKGBUILD
echo -e "sha256sums=('$HASH')" >> PKGBUILD
cat build >> PKGBUILD
cat package >> PKGBUILD
