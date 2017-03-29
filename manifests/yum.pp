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
#   Author: Sophia Katzy <sophia.katzy@gmail.com>

define drbdmanage::yum (
  $url,
  $hash,
){
  yumrepo { 'drbd9':
    descr    => 'LINBIT Packages for drbd-9.0 - $basearch',
    name     => 'linbit',
    baseurl  => $url,
    enabled  => 1,
    gpgkey   => 'https://packages.linbit.com/package-signing-pubkey.asc',
    gpgcheck => 1,
    priority => 1,
  }
  file {
    '/var/lib/drbd-support/registration.json':
      ensure  => present,
      content => template('drbdmanage/registration.json.erb'),
      owner   => root,
      group   => root,
      before  => Yumrepo['drbd9'];
    '/usr/share/yum-plugins/linbit.py':
      ensure => present,
      source => 'puppet:///modules/drbdmanage/linbit.py',
      owner  => root,
      group  => root,
      before => Yumrepo['drbd9'];
    '/etc/yum/pluginconf.d/linbit.conf':
      ensure => present,
      source => 'puppet:///modules/drbdmanage/linbit.conf',
      owner  => root,
      group  => root,
      before => Yumrepo['drbd9'];
  }
}
