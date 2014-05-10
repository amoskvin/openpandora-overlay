# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2

DESCRIPTION="First run wizard"
HOMEPAGE="http://example.org"
SRC_URI="${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm amd64"
IUSE=""

DEPEND="x11-apps/xinit
    >=dev-qt/qtgui-4.8"
RDEPEND="${DEPEND}"

src_install() {
	dobin frwizard

	exeinto /usr/lib/frwizard/scripts
	doexe scripts/xinitrc

	exeinto /usr/lib/frwizard/scripts/openrc
	doexe scripts/openrc/*.sh

	newinitd frwizard.rc frwizard
}
