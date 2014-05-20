# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Pandora tools including ofbset and op_test_inputs"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-misc.git"

if [[ ${PV} == "9999" ]] ; then #TODO 99999999
	inherit git-2
	EGIT_REPO_URI="git://git.openpandora.org/pandora-misc.git"
	KEYWORDS=""
else
	SRC_URI="http://gentoo.openpandora.org/source/snapshots/${P}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	x11-libs/tslib
	x11-libs/libX11"

RDEPEND="${DEPEND}
	sys-apps/fbset
	sys-apps/pandora-scripts"

src_prepare() {
	# Don't pre-strip
	sed -i -e '/^LDFLAGS += -s$/d' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake INSTALL="${D}/usr/bin" install
}
