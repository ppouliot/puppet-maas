# == Define: maas::network
# A defined type for maas network commands
#
# == Parameters:
#
# [*maas_superuser*]
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
#   maas_superuser    => 'admin',
#   cli_command       => 'update',
#   param_ip          => '192.168.1.0',
#   param_netmask     => '255.255.255.0',
#   param_vlan_tag    => '255.255.255.0',
#   param_description => 'Production Network'
# {
#
define maas::network (
  $maas_superuser,
  $cli_command,
  $param_ip           => undef,
  $param_netmask      => undef,
  $param_vlan_tag     => undef, 
  $param_description  => undef, 
  $param_macs         => undef, 
){
  ## Maas Command to add a network
  validate_re($cli_command, '(list-connected-macs|connect-macs|read|update|disconnect-macs|delete)$', 'Valid network commands are "list-connected-macs","connect-macs","read","update","disconnect-macs","delete".')
  ## Login as Maas Superuser
  notify{ "login-superuser-with-api-key-${maas::maas_superuser}":} warning("Login to maas profile: ${maas::profile} with ${maas::maas_superuser}") ->
  ## Generate Maas commandi argument for network command
  case $cli_command {
    'list-connected-macs','read','delete':{
      $command_argument = undef
    }
    'connect-macs','disconnect-macs':{
      $command_argument = "${param_macs}"
    }
    'update':{
      $command_argument = "ip=${param_ip} netmask=${param_netmask} vlan_tag=${param_vlan_tag} description=${param_description}",
    }
  }
  ## Maas command for network command
  exec{"maas-network-${cli_command}-${name}":
    command     => "/usr/bin/maas ${maas::profile_name} network ${cli_command} ${name} ${command_arguments}",
    cwd         => '/etc/maas/.puppet',
    refreshonly => true,
    logoutput   => true,
    before      => Exec["logout-superuser-with-api-key-${maas::superuser}"],
    require     => Exec["login-superuser-with-api-key-${maas::superuser}"],
  } ->
  notify{ "logout-superuser-with-api-key-${maas::maas_superuser}":} warning("Logging Out maas superuser ${maas::maas_superuser}")
}
