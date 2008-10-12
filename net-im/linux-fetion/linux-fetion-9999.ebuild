# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://libfetion-gui.googlecode.com/svn/trunk/qt4_src"
inherit flag-o-matic qt4 subversion
DESCRIPTION="Linux Fetion, a QT4 IM client using CHINA MOBILE's Fetion Protocol"
HOMEPAGE="http://www.libfetion.cn/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="dev-libs/openssl
	net-misc/curl
	|| ( ( x11-libs/qt-gui x11-libs/qt-qt3support )
		( >=x11-libs/qt-4.3 ) )"
RDEPEND="${DEPEND}"

RESTRICT="primaryuri"

src_compile() {
	filter-ldflags -Wl,--as-needed

	if use amd64 ; then
		sed -i -e "/libfetion.a/c    LIBS +=  -lcurl ./libfetion_64.a" ${PN}.pro
		sed -i -e "/libfetion_32.a/c    LIBS +=  -lcurl ./libfetion_64.a" ${PN}.pro
	fi

	# eqmake4 dies on itself.
	eqmake4
	emake || die "emake fail"
}

src_install() {
	insinto /usr/share/libfetion
	doins fetion_utf8_CN.qm
	doins -r skins sound

	insinto /usr/share/pixmaps
	doins misc/fetion.png

	if use doc ; then
		insinto /usr/share/doc/${PF}
		dohtml APIDocs/html/*
	fi

	ebegin "Remove empty directories"
		rm -rf $(find "${D}" -name .svn)
	eend $?

	insinto /usr/share/applications
	doins misc/LibFetion.desktop

	dobin ${PN}
}