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

define drbdmanage::resource {
  $resources = $name

  $ressource_array = split($resources, ':')
  $ressource_name = $ressource_array[0]
  $fact_name = getvar("${ressource_name}_join")

    exec { "add_$ressource_name":
    path    => "/sbin:/bin:/usr/sbin:/usr/bin",
    command => "drbdmanage new-node $ressource_name $node_ip",
    unless  => "drbdmanage resources -m | grep $ressource_name",
  }

  if $fact_name {
    @@exec { "join_$ressource_name":
      path    => "/sbin:/bin:/usr/sbin:/usr/bin",
      command => "$fact_name -q",
      unless  => "drbdmanage resources -m | grep $ressource_name",
      tag     => "$ressource_name",
    }
  }
}
