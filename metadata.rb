# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'kindle'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs/Configures the Kindle app'
long_description 'Installs/Configures the Kindle app'
version          '0.1.0'

depends          'mac-app-store', '~> 1.0'
depends          'dmg', '~> 2.2'
depends          'windows', '~> 1.36'

supports         'mac_os_x'
supports         'windows'
# rubocop:enable SingleSpaceBeforeFirstArg
