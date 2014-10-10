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
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#   implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Author: Martin Loschwitz <m.loschwitz@syseleven.de>

class drbdmanage::params {

  # The variable prefix to be used for configuration settings:
  # * default '' to resemble previous behaviour
  if $configuration_prefix {
    $variable_prefix = $configuration_prefix
  } else {
    $variable_prefix = ''
  }

  # The control node that needs to be installed first
  $master_node = getvar("::${variable_prefix}master_node")

  # The IP of the master node
  $master_ip = getvar("::${variable_prefix}master_ip")

  # The control node that needs to be installed first
  $nodes = getvar("::${variable_prefix}nodes")

  # Whether to add the repositories to the system or not
  $install_repositories = pick(getvar("::${variable_prefix}install_repositories"),
                           'true')

  # The name of the physical volume to be used by drbdmanage
  $physical_volume = getvar("::${variable_prefix}physical_volume")

  # The name of the VG to be used by DRBD
  $vg_name = pick(getvar("::${variable_prefix}vg_name"),
                           'drbdpool')

  # An array containing a list of all nodes that are part of the cluster
  $cluster_nodes = ['compute', 'controller']
}
