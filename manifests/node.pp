# == Define: maas::node
# A defined type for maas node commands
#
# == Parameters:
#
# [*maas_superuser*]
#   The maas superuser to use.
#
# [*cli_command*]
#   The maas node command to run
#
# [*p_user_data*]
#   The user_data address of the node
#
# [*t_user_data*]
#   Network user_data
#
# [*p_distro_series*]
#   Vlan Tag
#
# [*t_distro_series*]
#   Descruser_datation of Network
#
# [*p_power_type*]
#   Mac address
#
# == Example:
# maas::node{
#   maas_superuser      => 'admin',
#   cli_command         => 'start',
#   p_user_data     => 'foo',
#   t_user_data      => 'bar',
#   p_distro_series    => 'ubuntu',
#   t_distro_series => 'ubuntu'
# {
#
define maas::node (
  $maas_superuser,
  $cli_command,
  $p_user_data,
  $t_user_data,
  $p_distro_series,
  $t_distro_series,
  $p_power_type,
  $t_power_type,
  $p_pt_skipcheck,
  $t_pt_skipcheck,
  $p_zone,
  $t_zone,
){
  ## Maas Command to add a node
  validate_re($cli_command, '(start|stop|read|commission|update|details|release|delete)$', 'Valid node commands are "start","stop","read","update","details","release","delete".')
  ## Login as Maas Superuser
  notify{ "login-superuser-with-api-key-${maas::maas_superuser}":}
  warning("Login to maas profile: ${maas::profile} with ${maas::maas_superuser}")
  ## Generate Maas commandi argument for node command
  case $cli_command {
    'start','stop': {
      $command_arguments = ":param user_data=${p_user_data} :type user_data=${t_user_data} :param distro_series=${p_distro_series} :type distro_series=${t_distro_series}"
    }
    'update': {
      $command_arguments = ":param user_data=${p_user_data} :type user_data=${t_user_data} :param distro_series=${p_distro_series} :type distro_series=${t_distro_series} :param ${p_power_type} :type ${t_power_type} :param power_t_skipcheck=${p_pt_skipcheck} :type power_t_skipcheck=${t_pt_skipcheck} :param zone=${p_zone} :type zone=${t_zone}"
    }
    'commission','read','release','delete','details': {
      $command_arguments = undef
    }
    default: {
      notify {"CLI command ${cli_command} not defined.":}
    }
  }
  ## Maas command for node command
  exec{"maas-node-${cli_command}-${name}":
    command     => "/usr/bin/maas ${maas::profile_name} node ${cli_command} ${name} ${::command_arguments}",
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    before      => Exec["logout-superuser-with-api-key-${maas::superuser}"],
    require     => Exec["login-superuser-with-api-key-${maas::superuser}"],
  } ->
  notify{ "logout-superuser-with-api-key-${maas::maas_superuser}":} warning("Logging Out maas superuser ${maas::maas_superuser}")
}
