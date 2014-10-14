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
#   Authors: Martin Loschwitz <m.loschwitz@syseleven.de>
#            Martin Zdrahal <martin.zdrahal@s-team.at>

require 'puppet'

if File.exists?("/usr/bin/drbdmanage")
  nodes = []
  output = Puppet::Util::Execution.execute("drbdmanage nodes -m")

  String(output).each_line do |s|
      nodes << s[/(.*?),/,1]
  end

  nodes.each do |node|

    Facter.add("#{node}_join") do
      setcode do
        Puppet::Util::Execution.execute("drbdmanage howto-join #{node} 2>/dev/null").chop
      end
    end
  end
end
