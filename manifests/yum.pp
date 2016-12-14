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

define drbdmanage::yum {
  yumrepo { 'drbd9':
    name     => 'LINBIT Packages for drbd-9.0 - $basearch',
    baseurl  => undef,
    enabled  => 1
    gpgkey   => 'https://packages.linbit.com/package-signing-pubkey.asc',
    gpgcheck => 1
    before   => Package[
      'kmod-drbd',
      'drbd',
    ],
  }
}
