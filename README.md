### shibboleth-overlay ###

A gentoo overlay to install shibboleth-sp for apache2.4 (fork from flyser).

### Usage ###

#### Using layman ####

Run `layman -o https://raw.github.com/nelsonglory/shibboleth-overlay/master/repositories.xml -f -a shibboleth && emerge -a shibboleth-sp`

#### Manual ####

Clone `https://github.com/nelsonglory/shibboleth-overlay.git` repository somewhere and add the path to the *PORTDIR_OVERLAY* variable in `/etc/portage/make.conf`

### State ###

Note as shibboleth does not release new versions that often, chances are good, that it is still current.
If not, you can likely just rename the ebuilds to the new version number.
