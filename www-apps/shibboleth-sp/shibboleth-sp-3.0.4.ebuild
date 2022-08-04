# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit apache-module eutils

DESCRIPTION="Standards-based middleware which provides Web Single SignOn (SSO) across or within organizational boundaries."
HOMEPAGE="http://www.shibboleth.net"
SRC_URI="https://shibboleth.net/downloads/service-provider/${PV}/${PN}-${PV}.tar.gz"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="ads doc odbc"

#S=${WORKDIR}/shibboleth-${PV}

DEPEND="dev-libs/openssl
	=dev-libs/log4shib-2.0.0
	dev-libs/xerces-c
	=dev-libs/xml-security-c-2.0.2
	=dev-cpp/xmltooling-3.0.4
	=dev-cpp/opensaml-3.0.1"

APACHE2_MOD_FILE="${S}/apache/.libs/mod_shib_24.so"
APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="AUTH_SHIB"

need_apache2_4

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_configure() {
	econf \
	    $(use_enable odbc) \
	    $(use_enable ads adfs) \
	    --enable-apache-24 \
	    --with-apxs24=/usr/sbin/apxs2 \
	    --localstatedir=/var \
	    || die "Configuration failed."
}

src_compile() {
	emake || die "Compilation failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	apache-module_src_install
	newinitd "${FILESDIR}"/shibd-init.d shibd
	newconfd "${FILESDIR}"/shibd-conf.d shibd

#	dodoc FAQ NEWS README
#	dohtml EXTENDING.html ctags.html
}
