# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Firmware blobs for Pandora"
HOMEPAGE="http://git.openpandora.org/cgi-bin/gitweb.cgi?p=openpandora.oe.git;a=tree;f=recipes/pandora-system/pandora-firmware"
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

LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	local dir="${S}/recipes/pandora-system/pandora-firmware"

	insinto /lib/firmware
	doins "${dir}/brf6300.bin"
	doins "${dir}/wl1251-fw.bin"
}
