# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Library of various Pandora functions"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-libraries.git"

if [[ ${PV} == "99999999" ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.openpandora.org/pandora-libraries.git"
	KEYWORDS=""
else
	SRC_URI="http://gentoo.openpandora.org/source/snapshots/pandora-libraries-${PV}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="arm"
fi

LICENSE="LGPL"
SLOT="0"
IUSE=""

DEPEND="dev-libs/tinyxml"
RDEPEND="${DEPEND}"

S="${WORKDIR}/pandora-libraries"

src_prepare() {
	# Respect LDFLAGS
	sed -i -e 's:\(${CC} -shared\):\1 $(LDFLAGS):' Makefile || die

	# Bundled libs bad.
	sed -i -e 's:^\(XMLOBJ =\).*:\1:' Makefile || die
	sed -i -e 's:"tinyxml/tinyxml.h":<tinyxml.h>:' lib/pnd_tinyxml.cpp || die
	append-ldflags -ltinyxml
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LDFLAGS="${LDFLAGS}" libpnd.so.1.0.1
}

src_install() {
	insinto /usr/include
	doins include/*


	dolib libpnd.so.*
	dodoc -r docs CHANGES libpnd.txt
}
