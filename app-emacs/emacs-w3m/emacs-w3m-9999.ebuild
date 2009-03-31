# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit elisp cvs autotools

DESCRIPTION="Emacs-w3m is an interface program of w3m on Emacs"
HOMEPAGE="http://emacs-w3m.namazu.org"
ECVS_SERVER="cvs.namazu.org:/storage/cvsroot"
ECVS_MODULE="emacs-w3m"
ECVS_BRANCH="HEAD"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

DEPEND="virtual/w3m"
RDEPEND="${DEPEND}"

SITEFILE=71${PN}-gentoo.el

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	eautoreconf
}

# This is NOT redundant: elisp.eclass redefines src_compile() from default
src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake lispdir="${D}"/${SITELISP}/${PN} \
		infodir="${D}"/usr/share/info \
		ICONDIR="${D}"/usr/share/pixmaps/${PN} \
		install install-icons || die "emake install failed"

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog* README*
}

pkg_postinst() {
	elisp-site-regen
	einfo "Please see /usr/share/doc/${PF}/README*"
	einfo
	elog "If you want to use the shimbun library, please emerge app-emacs/apel"
	elog "and app-emacs/flim."
	einfo
}

pkg_postrm() {
	elisp-site-regen
}
