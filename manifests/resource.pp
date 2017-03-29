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

define drbdmanage::resource (
  $size,
){
  $resources = $name

  $resource_array = split($resources, ':')
  $resource_name = $resource_array[0]

  exec { "add_resource_${resource_name}":
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
    command => "drbdmanage add-volume ${resource_name} ${size} --deploy 2",
    #    unless  => "drbdmanage resources -m | grep $resource_name",
  }
}
