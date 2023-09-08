# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit apache-module depend.apache tmpfiles

DESCRIPTION="Standards-based middleware which provides Web Single SignOn (SSO) across or within organizational boundaries."
HOMEPAGE="http://www.shibboleth.net"
SRC_URI="https://shibboleth.net/downloads/service-provider/${PV}/${PN}-${PV}.tar.gz"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="ads doc odbc fastcgi"

#S=${WORKDIR}/shibboleth-${PV}

DEPEND="dev-libs/openssl
	=dev-libs/log4shib-2.0.1
	dev-libs/xerces-c
	=dev-libs/xml-security-c-2.0.4
	=dev-cpp/xmltooling-3.2.4
	=dev-cpp/opensaml-3.2.1"

RDEPEND="dev-libs/fcgi"

APACHE2_MOD_FILE="${S}/apache/.libs/mod_shib_24.so"
APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="AUTH_SHIB"

need_apache2_4

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#}

# --with-apxs24=/usr/sbin/apxs2 \

src_configure() {
	econf \
		$(use_enable odbc) \
		$(use_enable ads adfs) \
		$(use_with fastcgi) \
		--enable-apache-24 \
		--localstatedir=/var
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	apache-module_src_install
	newinitd "${FILESDIR}"/shibd-init.d shibd
	newconfd "${FILESDIR}"/shibd-conf.d shibd

#	dodoc FAQ NEWS README
#	dohtml EXTENDING.html ctags.html
}
