# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="OpenPandora op_* scripts"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=openpandora.oe.git;a=tree;f=recipes/pandora-system/pandora-scripts"
SRC_URI=""

if [[ ${PV} == "99999999" ]] ; then
    inherit git-2
    EGIT_REPO_URI="git://git.openpandora.org/openpandora.oe.git"
    KEYWORDS=""
else
    SRC_URI="http://gentoo.openpandora.org/source/snapshots/${P}.tar.xz"
	RESTRICT="primaryuri"
    KEYWORDS="arm"
fi

LICENSE="LGPL"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-power/pm-utils
	sys-apps/pandora-misc-files"

src_install() {
	local scripts="${S}/recipes/pandora-system/pandora-scripts"

	exeinto /usr/pandora/scripts

	# Selectively install scripts, so that we ship only ones that work
	doexe "${scripts}/op_common.sh"
	doexe "${scripts}/op_bright_up.sh"
	doexe "${scripts}/op_bright_down.sh"
	doexe "${scripts}/op_nubchange.sh"
	doexe "${scripts}/op_sysspeed.sh"
	doexe "${scripts}/op_touchinit.sh"
	doexe "${scripts}/op_usbhost.sh"

	# Custom ones, since we use pm-utils for suspend
	doexe "${FILESDIR}/op_lid.sh"
	doexe "${FILESDIR}/op_power.sh"
}
