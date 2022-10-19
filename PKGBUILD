# Maintainer: ptrkbmn

pkgname=element-desktop-bin
pkgver=1.11.10
pkgrel=1
pkgdesc="All-in-one secure chat app for teams, friends and organisations (nightly .deb build)."
arch=('x86_64')
url="https://element.io"
license=('Apache')
depends=('sqlcipher')
source=("https://packages.element.io/debian/pool/main/e/element-desktop/element-desktop_${pkgver}_amd64.deb"
        "element-desktop.sh")
sha256sums=('9fdba0920106634ab1de4e03500fa8e61f24f86d059e67c63ba5660def8f0191'
            'b682d6ec847e0b6e5406313fbb6a5ed8c445eda2a873432b5645693a258ba98b')
replaces=('element-desktop')

package() {
  msg2 "Extracting the data.tar.xz..."
  bsdtar -xf data.tar.xz -C "$pkgdir/"
  install -Dm755 "${srcdir}"/element-desktop.sh "${pkgdir}"/usr/bin/element-desktop
  sed -i 's|^Exec=.*|Exec=/usr/bin/element-desktop %U|' "${pkgdir}"/usr/share/applications/element-desktop.desktop
}
