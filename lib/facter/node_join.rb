# node_join.rb
nodes = []
output = Puppet::Util::Execution.execute("drbdmanage nodes -m")

String(output).each_line do |s|
  line = s.to_s
  line.split(/\s*,\s*/)
  nodes.push $1
end

nodes.each do |node|
  
  output = Puppet::Util::Execution.execute("drbdmanage howto-join #{node}")
  fact_name = "#{node}_join"
  
  Facter.add(:fact_name) do
    setcode do
      output
    end
  end

end
