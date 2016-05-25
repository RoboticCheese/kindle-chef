# Encoding: UTF-8

name             'kindle'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs/Configures the Kindle app'
long_description 'Installs/Configures the Kindle app'
version          '1.0.1'

source_url 'https://github.com/roboticcheese/kindle-chef'
issues_url 'https://github.com/roboticcheese/kindle-chef/issues'

depends 'mac-app-store', '~> 2.0'
depends 'dmg', '~> 2.2'

supports 'mac_os_x'
supports 'windows'
