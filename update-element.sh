#!/bin/bash

echo "Retrieving latest package information..."

offsetHead=54
offsetTail=21

wget -qN https://packages.element.io/debian/dists/default/main/binary-amd64/Packages -O Packages
version=$(head -$offsetHead Packages | tail -$offsetTail | sed -n '/^Version/ {p;q}' | cut -d' ' -f2)
echo "Version: $version"

echo "Checking PKGBUILD..."

pkgbuildVersion=$(sed -n '/^pkgver/ {p;q}' PKGBUILD | cut -d'=' -f2)
echo "Version: $pkgbuildVersion"

if [ $version == $pkgbuildVersion ];
then
  rm Packages

  echo "PKGBUILD is already up-to-date"
else
  sha256=$(head -$offsetHead Packages | tail -$offsetTail | sed -n '/^SHA256/ {p;q}' | cut -d' ' -f2)

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
