# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="OpenPandora op_* scripts"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=openpandora.oe.git;a=tree;f=recipes/pandora-system/pandora-scripts"

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
	sys-devel/bc
	sys-power/pm-utils
	sys-apps/pandora-misc
	sys-apps/pandora-misc-files"

src_install() {
	local scripts="recipes/pandora-system/pandora-scripts"

	insinto /etc/pandora/conf
	echo -n 100 > dssgamma.state # TODO: include pandora-state in next tarball
	doins "dssgamma.state"
	doins "${scripts}/tvout-profiles.conf"

	insinto /etc/pandora/conf/dss_fir
	doins "${scripts}/default_up"
	doins "${scripts}/none_up"

	exeinto /usr/pandora/scripts

	# Selectively install scripts, so that we ship only ones that work
	doexe "${scripts}/op_common.sh"
	doexe "${scripts}/op_bright_up.sh"
	doexe "${scripts}/op_bright_down.sh"
	doexe "${scripts}/op_gamma.sh"
	doexe "${scripts}/op_hugetlb.sh"
	doexe "${scripts}/op_lcdrate.sh"
	doexe "${scripts}/op_nubchange.sh"
	doexe "${scripts}/op_sysspeed.sh"
	doexe "${scripts}/op_touchinit.sh"
	doexe "${scripts}/op_tvout.sh"
	doexe "${scripts}/op_tvout_layer.sh"
	doexe "${scripts}/op_usbhost.sh"
	doexe "${scripts}/op_videofir.sh"
	doexe "${scripts}/reset_nubs.sh"

	# Custom ones, since we use pm-utils for suspend
	doexe "${FILESDIR}/op_lid.sh"
	doexe "${FILESDIR}/op_power.sh"
}
