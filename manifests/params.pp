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

  # An array containing a list of all nodes that are part of the cluster
  $cluster_nodes = hiera('drbdmanage::params::cluster_nodes',
                            getvar("::${variable_prefix}cluster_nodes"))

  # The control node that needs to be installed first
  $master_node = hiera('drbdmanage::params::master_node',
                            getvar("::${variable_prefix}master_node"))

  # The IP of the master node
  $master_ip = hiera('drbdmanage::params::master_ip',
                            getvar("::${variable_prefix}master_ip"))

  # Whether to add the repositories to the system or not
  $install_repositories = hiera('drbdmanage::params::install_repositories',
                            getvar("::${variable_prefix}install_repositories"))

  # The name of the physical volume to be used by drbdmanage
  $physical_volume = hiera('drbdmanage::params::physical_volume',
                            getvar("::${variable_prefix}physical_volume"))

  # The name of the VG to be used by DRBD
  $vg_name = hiera('drbdmanage::params::vg_name',
                            getvar("::${variable_prefix}vg_name"))

}
