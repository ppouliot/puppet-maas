# == Define: maas::network
# A defined type for maas network commands
#
# == Parameters:
#
# [*default_superuser*]
#   The maas superuser to use.
#
# [*cli_command*]
#   The maas network command to run
#
# [*param_ip*]
#   The ip address of the network
#
# [*param_netmask*]
#   Network netmask
#
# [*param_vlan_tag*]
#   Vlan Tag
#
# [*param_description*]
#   Description of Network
#
# [*param_macs*]
#   Mac address
#
# == Example:
# maas::network{
#   default_superuser    => 'admin',
#   cli_command       => 'update',
#   param_ip          => '192.168.1.0',
#   param_netmask     => '255.255.255.0',
#   param_vlan_tag    => '255.255.255.0',
#   param_description => 'Production Network'
# {
#
define maas::network (
  $cli_command,
  $param_ip,
  $param_netmask,
  $param_vlan_tag,
  $param_description,
  $param_macs,
){
  ## Maas Command to add a network
  validate_re($cli_command, '(list-connected-macs|connect-macs|read|update|disconnect-macs|delete)$', 'Valid network commands are "list-connected-macs","connect-macs","read","update","disconnect-macs","delete".')
  ## Login as Maas Superuser
  notify{ "login-superuser-with-api-key-${maas::default_superuser}":} warning("Login to maas profile: ${maas::profile} with ${maas::default_superuser}") ->
  ## Generate Maas command argument for network command
  case $cli_command {
    'list-connected-macs','read','delete': {
      $command_arguments = undef
    }
    'connect-macs','disconnect-macs': {
      $command_arguments = "macs=${param_macs}"
    }
    'update': {
      $command_arguments = "ip=${param_ip} netmask=${param_netmask} vlan_tag=${param_vlan_tag} description=${param_description}"
    }
    default: {
      notify {"CLI command ${cli_command} not defined.":}
    }
  }
  ## Maas command for network command
  exec{"maas-network-${cli_command}-${name}":
    command     => "/usr/bin/maas ${maas::profile_name} network ${cli_command} ${name} ${::command_arguments}",
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    before      => Exec["logout-superuser-with-api-key-${maas::superuser}"],
    require     => Exec["login-superuser-with-api-key-${maas::superuser}"],
  } ->
  notify{ "logout-superuser-with-api-key-${maas::default_superuser}":} warning("Logging Out maas superuser ${maas::default_superuser}")
}
