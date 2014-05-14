# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Utility to save and restore nub configuration"
HOMEPAGE="http://openpandora.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	$(tc-getCC) -std=gnu99 ${CFLAGS} ${LDFLAGS} -DVERSION=\"${PV}\" -o "${PN}" "${FILESDIR}/nub-state.c" || die
}

src_install() {
	dobin "${PN}"

	insinto /etc/pandora/conf/
	doins "${FILESDIR}/nubs.state"

	newinitd "${FILESDIR}/nub-state.rc" nub-state
}
