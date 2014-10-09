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

  # The control node that needs to be installed first
  $nodes = getvar("::${variable_prefix}nodes")

  # Whether to add the repositories to the system or not
  $install_repositories = pick(getvar("::${variable_prefix}install_repositories"),
                           'true')
}
