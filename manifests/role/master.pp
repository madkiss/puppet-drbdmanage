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
# [*physical_volume*]
#   (required) The physical volume that drbdmanage is supposed to use
#
# [*master_ip*]
#   (required) The IP this node will use when talking to other nodes
#
# [*poolname*]
#   (optional) The name of the PV to be used by drbdmanage
#   Default: drbdpool
#
# [*cluster_nodes*]
#   (required) An array of hosts to be part of this drbdmanage cluster

class drbdmanage::role::master(
  $physical_volume = $drbdmanage::params::physical_volume,
  $master_ip = $drbdmanage::params::master_ip,
  $cluster_nodes = $drbdmanage::params::cluster_nodes,
) inherits drbdmanage::params {

## Create the drbdmanaged master instance

  exec { "drbd-init":
    path    => "/sbin:/usr/bin:/usr/sbin:/bin",
    command => "drbdmanage init --quiet $master_ip",
    unless  => "drbdmanage nodes -m | grep $::hostname",
  }

  drbdmanage::addtocluster { $cluster_nodes: }
}
