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

define drbdmanage::addtocluster(
  $master_node = $drbdmanage::params::master_node,
) inherits drbdmanage::params {
  if $name != $master_node {
    $nodes = $name

    $node_array = split($nodes, ':')
    $node_name = $node_array[0]
    $node_ip = $node_array[1]
    $fact_name = getvar("${node_name}_join")

    exec { "add_$node_name":
      path    => "/sbin:/bin:/usr/sbin:/usr/bin",
      command => "drbdmanage new-node $node_name $node_ip",
      unless  => "drbdmanage nodes -m | grep $node_name",
    }

    if $fact_name {
      @@exec { "join_$node_name":
        path    => "/sbin:/bin:/usr/sbin:/usr/bin",
        command => "$fact_name -q",
        unless  => "drbdmanage nodes -m | grep $node_name",
        tag     => "$node_name",
      }
    }
  }
}
