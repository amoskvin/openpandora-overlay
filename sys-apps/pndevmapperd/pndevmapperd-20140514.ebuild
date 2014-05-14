# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Daemon that executes scripts on hardware events"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-libraries.git"

if [[ ${PV} == "99999999" ]] ; then
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

DEPEND="sys-libs/libpnd"
RDEPEND="${DEPEND}"

S="${WORKDIR}/pandora-libraries"

src_prepare() {
	epatch "${FILESDIR}/${PN}-create-a-pid-file.patch"
	epatch "${FILESDIR}/${PN}-make-delay-hack-optional.patch"
}

src_compile() {
    $(tc-getCC) ${CFLAGS} -DNO_DELAY_HACK -o "${PN}".o -c "apps/${PN}.c" || die
	$(tc-getCXX) -o "${PN}" "${PN}".o ${LDFLAGS} -l:libpnd.so.1 || die
}

src_install() {
	dobin "${PN}"
	insinto "/etc/pandora/conf"
	doins "deployment/etc/pandora/conf/eventmap"
	newinitd "${FILESDIR}/pndevmapperd.rc" pndevmapperd
}
