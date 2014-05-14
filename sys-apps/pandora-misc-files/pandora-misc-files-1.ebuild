# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit systemd

DESCRIPTION="Various pandora-specific files"
HOMEPAGE="http://openpandora.org"
SRC_URI=""

LICENSE="GPL"
SLOT="0"
KEYWORDS="~arm arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /etc
	doins "${FILESDIR}/keymap-extension-2.6.map"
	doins -r "${FILESDIR}/X11"
	doins -r "${FILESDIR}/polkit-1"

	insinto /etc/xdg/autostart
	doins "${FILESDIR}/wpa_gui.desktop"

	# Doesn't get triggered on boot :/
	#insinto /lib
	#doins -r "${FILESDIR}/udev"
	
	exeinto /etc/pm/sleep.d
	doexe "${FILESDIR}"/pm/sleep.d/*
	insinto /etc/pm/config.d
	doins "${FILESDIR}/pm/config.d/pandora"

	systemd_newtmpfilesd "${FILESDIR}/pandora.tmpfiles" pandora.conf
}
