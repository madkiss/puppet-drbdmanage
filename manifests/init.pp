#   Copyright 2014 SysEleven GmbH
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Author: Martin Loschwitz <m.loschwitz@syseleven.de>

# === Parameters:
#
# [*master_node*]
#   (required) The node running the first instance of drbdmanaged
#
# [*nodes*]
#   (required) An array containing all other DRBD 9 cluster nodes
#
# [*install_repositories*]
#   (optional) Whether to add DRBD 9 repositories to the system
#   Default: yes

class drbdmanage(
  $master_node = $drbdmanage::params::master_node,
  $nodes = $drbdmanage::params::nodes,
  $install_repositories = $drbdmanage::params::install_repositories,
) inherits drbdmanage::params {

## Install DRBD9 and dependencies

  case $::osfamily {
    'Debian': {
      if $install_repositories == 'true' {
        drbdmanage::apt {'drbd9': }
      }
      $check_cmd = '/usr/bin/dpkg -l | grep drbd9-dkms'
    }
  }

  package {'drbd-utils':
    ensure => present,
  }

  package {'python-drbdmanage':
    ensure => present,
  }

  package {'drbd-dkms':
    ensure => present,
  }

}
