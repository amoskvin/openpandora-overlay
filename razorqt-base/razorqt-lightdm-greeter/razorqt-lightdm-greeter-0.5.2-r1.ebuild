# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/razorqt-base/razorqt-lightdm-greeter/razorqt-lightdm-greeter-0.5.2-r1.ebuild,v 1.1 2013/08/07 08:35:26 yngwin Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="Razor-qt LightDM greeter"
HOMEPAGE="http://razor-qt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="http://www.razor-qt.org/downloads/files/razorqt-${PV}.tar.bz2"
	KEYWORDS="~amd64 arm ~ppc ~x86"
	S="${WORKDIR}/razorqt-${PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="razorqt-base/razorqt-libs
	x11-misc/lightdm[qt4]"
RDEPEND="${DEPEND}
	razorqt-base/razorqt-data
	!x11-misc/lightdm-razorqt-greeter"

PATCHES=( "${FILESDIR}/lightdm-qt-3.patch" )

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_LIGHTDM=On
	)
	cmake-utils_src_configure
}
