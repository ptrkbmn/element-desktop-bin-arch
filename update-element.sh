#!/bin/bash

echo "Retrieving latest package information..."

wget -qN https://packages.element.io/debian/dists/default/main/binary-amd64/Packages -O Packages
version=$(sed -n '/^Version/ {p;q}' Packages | cut -d' ' -f2)
echo "Version: $version"

echo "Checking PKGBUILD..."

pkgbuildVersion=$(sed -n '/^pkgver/ {p;q}' PKGBUILD | cut -d'=' -f2)
echo "Version: $pkgbuildVersion"

if [ $version == $pkgbuildVersion ];
then
  rm Packages

  echo "PKGBUILD is already up-to-date"
else
  sha256=$(sed -n '/^SHA256/ {p;q}' Packages | cut -d' ' -f2)
  sed -i "s|^pkgver=.*|pkgver="$version"|" PKGBUILD
  sed -i "s|^sha256sums=.*|sha256sums=('"$sha256"'|" PKGBUILD

  echo "PKGBUILD updated"

  echo "Installing new version..."

  makepkg -i

  echo "Cleaning up..."

  rm .*
  rm Packages
  rm element-desktop_*.deb
  rm element-desktop-bin*.tar.zst
  rm -r src
  rm -r pkg

  echo "Element updated!"
fi
